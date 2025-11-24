from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore
import requests
from bs4 import BeautifulSoup
from datetime import datetime
import re
from urllib.parse import urlparse
from dateutil import parser
import os

app = Flask(__name__)
CORS(app)

# Configuration
CREDENTIALS_PATH = 'firebase-credentials.json'
db = None

def init_firebase():
    """Initialize Firebase connection if credentials exist"""
    global db
    try:
        if not firebase_admin._apps:
            if os.path.exists(CREDENTIALS_PATH):
                cred = credentials.Certificate(CREDENTIALS_PATH)
                firebase_admin.initialize_app(cred)
                db = firestore.client()
                print("Firebase initialized successfully")
            else:
                print(f"Warning: {CREDENTIALS_PATH} not found. Firebase features will be disabled.")
        else:
             db = firestore.client()
    except Exception as e:
        print(f"Error initializing Firebase: {e}")

# Initialize on startup
init_firebase()

# --- Article Scraper Helpers ---

def extract_title(soup):
    """Extract article title"""
    title_tags = [
        soup.find('h1'),
        soup.find('title'),
        soup.find('meta', property='og:title'),
        soup.find('meta', attrs={'name': 'title'})
    ]

    for tag in title_tags:
        if tag:
            if tag.name == 'meta':
                return tag.get('content', 'Untitled Article')
            return tag.get_text().strip()
    return "Untitled Article"

def extract_content(soup):
    """Extract main article content"""
    for script in soup(['script', 'style', 'nav', 'header', 'footer', 'aside']):
        script.decompose()

    content_candidates = [
        soup.find('article'),
        soup.find('div', class_=re.compile(r'content|article|post-body|entry-content', re.I)),
        soup.find('main'),
        soup.find('div', id=re.compile(r'content|article|main', re.I))
    ]

    content_element = None
    for candidate in content_candidates:
        if candidate:
            content_element = candidate
            break
    
    if not content_element:
        content_element = soup.find('body')

    if content_element:
        paragraphs = content_element.find_all('p')
        content = '\n\n'.join([p.get_text().strip() for p in paragraphs if p.get_text().strip()])
        if len(content) > 5000:
            content = content[:5000] + "..."
        return content if content else "Content not available"

    return "Content not available"

def extract_image(soup, url):
    """Extract featured image URL"""
    image_candidates = [
        soup.find('meta', property='og:image'),
        soup.find('meta', attrs={'name': 'twitter:image'}),
        soup.find('img', class_=re.compile(r'featured|hero|main', re.I)),
        soup.find('article').find('img') if soup.find('article') else None,
        soup.find('img')
    ]

    for candidate in image_candidates:
        if candidate:
            img_url = None
            if candidate.name == 'meta':
                img_url = candidate.get('content')
            else:
                img_url = candidate.get('src') or candidate.get('data-src')

            if img_url:
                if img_url.startswith('//'):
                    img_url = 'https:' + img_url
                elif img_url.startswith('/'):
                    parsed = urlparse(url)
                    img_url = f"{parsed.scheme}://{parsed.netloc}{img_url}"
                return img_url
    return ""

def extract_date(soup):
    """Extract article publish date"""
    date_candidates = [
        soup.find('meta', property='article:published_time'),
        soup.find('meta', attrs={'name': 'publish_date'}),
        soup.find('meta', attrs={'name': 'date'}),
        soup.find('time', attrs={'datetime': True}),
        soup.find('time'),
        soup.find('span', class_=re.compile(r'date|time|published', re.I)),
        soup.find('div', class_=re.compile(r'date|time|published', re.I))
    ]

    for candidate in date_candidates:
        if candidate:
            date_str = None
            if candidate.name == 'meta':
                date_str = candidate.get('content')
            elif candidate.name == 'time':
                date_str = candidate.get('datetime') or candidate.get_text().strip()
            else:
                date_str = candidate.get_text().strip()

            if date_str:
                try:
                    return parser.parse(date_str, fuzzy=True)
                except:
                    continue
    return datetime.now()

# --- Routes ---

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'ok', 'firebase': db is not None})

@app.route('/api/scrape-article', methods=['POST'])
def scrape_article_endpoint():
    if not db:
        return jsonify({'error': 'Firebase not initialized'}), 503

    data = request.get_json(silent=True) or {}
    url = data.get('url')
    category = data.get('category', 'Guide')
    author = data.get('author', 'Voice of Stray Dogs')

    if not url:
        return jsonify({'error': 'URL is required'}), 400

    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()

        soup = BeautifulSoup(response.content, 'html.parser')
        
        title = extract_title(soup)
        content = extract_content(soup)
        image_url = extract_image(soup, url)
        publish_date = extract_date(soup)

        article_data = {
            'title': title,
            'category': category,
            'author': author,
            'date': publish_date,
            'imageUrl': image_url,
            'content': content,
            'sourceUrl': url,
            'scrapedAt': datetime.now()
        }

        # Add to Firestore
        doc_ref = db.collection('articles').add(article_data)
        
        return jsonify({
            'success': True,
            'message': f"Article '{title}' added successfully",
            'id': doc_ref[1].id,
            'data': {k: v.isoformat() if isinstance(v, datetime) else v for k, v in article_data.items()}
        })

    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/scrape-ngos', methods=['GET'])
def scrape_ngos_endpoint():
    url = request.args.get('url', 'https://makenewlife.in/')
    
    try:
        response = requests.get(url, timeout=10)
        soup = BeautifulSoup(response.content, 'html.parser')
        data = []
        
        ngos_section = soup.find_all('div', class_='ngo-list')
        
        for ngo in ngos_section:
            name_tag = ngo.find('h2')
            address_tag = ngo.find('p', class_='address')
            contact_tag = ngo.find('p', class_='contact')
            
            if name_tag:
                data.append({
                    'name': name_tag.text.strip(),
                    'address': address_tag.text.strip() if address_tag else "",
                    'contact': contact_tag.text.strip() if contact_tag else ""
                })
        
        return jsonify({
            'success': True,
            'count': len(data),
            'ngos': data
        })

    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
