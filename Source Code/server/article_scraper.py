import json
import requests
from bs4 import BeautifulSoup
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore
import re
from urllib.parse import urlparse


class ArticleScraper:
    def __init__(self, firebase_credentials_path):
        """Initialize Firebase connection"""
        cred = credentials.Certificate(firebase_credentials_path)
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()

    def scrape_article(self, url, category="Guide", author="Voice of Stray Dogs"):
        """
        Scrape article content from a URL
        Args:
            url: Article URL to scrape
            category: Category (Guide, Medical, Stories)
            author: Author name (default: Voice of Stray Dogs)
        """
        try:
            print(f"Scraping: {url}")

            # Fetch the page
            headers = {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            }
            response = requests.get(url, headers=headers, timeout=10)
            response.raise_for_status()

            # Parse HTML
            soup = BeautifulSoup(response.content, "html.parser")

            # Extract title
            title = self._extract_title(soup)

            # Extract main content
            content = self._extract_content(soup)

            # Extract or generate image URL
            image_url = self._extract_image(soup, url)

            # Extract publish date
            publish_date = self._extract_date(soup)

            # Create article document
            article_data = {
                "title": title,
                "category": category,
                "author": author,
                "date": publish_date,
                "imageUrl": image_url,
                "content": content,
                "sourceUrl": url,
            }

            # Add to Firestore
            doc_ref = self.db.collection("articles").add(article_data)
            print(f"✓ Added article: {title}")
            print(f"  Document ID: {doc_ref[1].id}")

            return True

        except Exception as e:
            print(f"✗ Error scraping {url}: {str(e)}")
            return False

    def _extract_title(self, soup):
        """Extract article title"""
        # Try various title tags
        title_tags = [
            soup.find("h1"),
            soup.find("title"),
            soup.find("meta", property="og:title"),
            soup.find("meta", attrs={"name": "title"}),
        ]

        for tag in title_tags:
            if tag:
                if tag.name == "meta":
                    return tag.get("content", "Untitled Article")
                return tag.get_text().strip()

        return "Untitled Article"

    def _extract_content(self, soup):
        """Extract main article content"""
        # Remove script and style elements
        for script in soup(["script", "style", "nav", "header", "footer", "aside"]):
            script.decompose()

        # Try to find main content area
        content_candidates = [
            soup.find("article"),
            soup.find(
                "div",
                class_=re.compile(r"content|article|post-body|entry-content", re.I),
            ),
            soup.find("main"),
            soup.find("div", id=re.compile(r"content|article|main", re.I)),
        ]

        content_element = None
        for candidate in content_candidates:
            if candidate:
                content_element = candidate
                break

        if not content_element:
            content_element = soup.find("body")

        # Get text content
        if content_element:
            paragraphs = content_element.find_all("p")
            content = "\n\n".join(
                [p.get_text().strip() for p in paragraphs if p.get_text().strip()]
            )

            # Limit content length
            if len(content) > 5000:
                content = content[:5000] + "..."

            return content if content else "Content not available"

        return "Content not available"

    def _extract_image(self, soup, url):
        """Extract featured image URL"""
        # Try various image sources
        image_candidates = [
            soup.find("meta", property="og:image"),
            soup.find("meta", attrs={"name": "twitter:image"}),
            soup.find("img", class_=re.compile(r"featured|hero|main", re.I)),
            soup.find("article").find("img") if soup.find("article") else None,
            soup.find("img"),
        ]

        for candidate in image_candidates:
            if candidate:
                img_url = None
                if candidate.name == "meta":
                    img_url = candidate.get("content")
                else:
                    img_url = candidate.get("src") or candidate.get("data-src")

                if img_url:
                    # Make absolute URL
                    if img_url.startswith("//"):
                        img_url = "https:" + img_url
                    elif img_url.startswith("/"):
                        parsed = urlparse(url)
                        img_url = f"{parsed.scheme}://{parsed.netloc}{img_url}"

                    return img_url

        return ""

    def _extract_date(self, soup):
        """Extract article publish date"""
        from dateutil import parser

        # Try various date sources
        date_candidates = [
            soup.find("meta", property="article:published_time"),
            soup.find("meta", attrs={"name": "publish_date"}),
            soup.find("meta", attrs={"name": "date"}),
            soup.find("time", attrs={"datetime": True}),
            soup.find("time"),
            soup.find("span", class_=re.compile(r"date|time|published", re.I)),
            soup.find("div", class_=re.compile(r"date|time|published", re.I)),
        ]

        for candidate in date_candidates:
            if candidate:
                date_str = None
                if candidate.name == "meta":
                    date_str = candidate.get("content")
                elif candidate.name == "time":
                    date_str = candidate.get("datetime") or candidate.get_text().strip()
                else:
                    date_str = candidate.get_text().strip()

                if date_str:
                    try:
                        # Parse the date string
                        parsed_date = parser.parse(date_str, fuzzy=True)
                        return parsed_date
                    except:
                        continue

        # If no date found, use current timestamp
        return datetime.now()

    def add_articles_from_config(self, config_file):
        """
        Add multiple articles from a configuration file
        Config format: JSON array with {url, category, author} objects
        """
        try:
            with open(config_file, "r") as f:
                articles = json.load(f)

            success_count = 0
            total_count = len(articles)

            for article in articles:
                url = article.get("url")
                category = article.get("category", "Guide")
                author = article.get("author", "Voice of Stray Dogs")

                if url:
                    if self.scrape_article(url, category, author):
                        success_count += 1

            print(f"\n{'='*50}")
            print(f"Successfully added {success_count}/{total_count} articles")
            print(f"{'='*50}")

        except Exception as e:
            print(f"Error reading config file: {str(e)}")


def main():
    """Main function to run the scraper"""
    import sys

    if len(sys.argv) < 2:
        print("Usage:")
        print("  python article_scraper.py <firebase-credentials.json> [config.json]")
        print("\nOr add single article:")
        print(
            "  python article_scraper.py <firebase-credentials.json> --url <url> --category <category>"
        )
        sys.exit(1)

    firebase_creds = sys.argv[1]
    scraper = ArticleScraper(firebase_creds)

    if len(sys.argv) > 2:
        if sys.argv[2] == "--url":
            # Single article mode
            url = sys.argv[3] if len(sys.argv) > 3 else None
            category = (
                sys.argv[5]
                if len(sys.argv) > 5 and sys.argv[4] == "--category"
                else "Guide"
            )

            if url:
                scraper.scrape_article(url, category)
            else:
                print("Please provide a URL")
        else:
            # Batch mode with config file
            config_file = sys.argv[2]
            scraper.add_articles_from_config(config_file)
    else:
        print("Please provide either a config file or use --url flag")


if __name__ == "__main__":
    main()
