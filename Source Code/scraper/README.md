# WoofCare Scraper API

A Flask API that combines article scraping (to Firebase) and NGO scraping.

## Setup

1. **Install Python dependencies:**
   ```bash
   cd scraper
   pip install -r requirements.txt
   ```

2. **Get Firebase Service Account Key:**
   - Go to Firebase Console → Project Settings → Service Accounts
   - Click "Generate New Private Key"
   - Save the JSON file as `firebase-credentials.json` in the `scraper` directory

## Usage

### Run the API Server

```bash
python app.py
```
The server will start on `http://localhost:5000`.

### Endpoints

#### 1. Scrape Article
Scrapes an article and adds it to Firebase Firestore.

- **URL:** `/api/scrape-article`
- **Method:** `POST`
- **Body:**
  ```json
  {
    "url": "https://example.com/article",
    "category": "Guide",
    "author": "Voice of Stray Dogs"
  }
  ```

#### 2. Scrape NGOs
Scrapes NGO information from a website.

- **URL:** `/api/scrape-ngos`
- **Method:** `GET`
- **Query Params:**
  - `url` (optional): URL to scrape (default: `https://makenewlife.in/`)

## Legacy Scripts

You can still run the standalone scripts:

### Article Scraper CLI


1. Edit `articles_config.json` with your article URLs:
   ```json
   [
     {
       "url": "https://example.com/article-url",
       "category": "Guide",
       "author": "Voice of Stray Dogs"
     }
   ]
   ```

2. Run the scraper:
   ```bash
   python article_scraper.py firebase-credentials.json articles_config.json
   ```

### Add Single Article

```bash
python article_scraper.py firebase-credentials.json --url <article-url> --category Guide
```

## Categories

- `Guide` - How-to guides and tips
- `Medical` - Health and medical information
- `Stories` - Inspirational stories

## What Gets Scraped

- Title
- Main content text
- Images (first image used as thumbnail)
- Publication date (if available)

## Adding New Sources

Simply add URLs to `articles_config.json`:

```json
[
  {
    "url": "https://newsite.com/article1",
    "category": "Medical",
    "author": "Voice of Stray Dogs"
  },
  {
    "url": "https://newsite.com/article2",
    "category": "Guide",
    "author": "Voice of Stray Dogs"
  }
]
```

Then run the scraper again to add new articles.

## Firestore Structure

Articles are stored with this structure:
```
articles/
  ├── {auto-generated-id}/
      ├── title: string
      ├── category: string (Guide/Medical/Stories)
      ├── author: string
      ├── date: timestamp
      ├── imageUrl: string
      ├── content: string
      └── sourceUrl: string
```

## Deploying Firestore Rules

Deploy the security rules to Firebase:
```bash
firebase deploy --only firestore:rules
```

## Notes

- The scraper uses intelligent content extraction to find article text and images
- Images are automatically converted to absolute URLs
- Content is limited to 5000 characters to keep the database clean
- The app's frontend will automatically display new articles in real-time

# NGO Scraper

Scrapes NGO information from `https://makenewlife.in/` and saves it to a CSV file.

## Usage

```bash
python ngo_scraper.py
```

The script will generate `ngos_pune.csv` containing:
- NGO Name
- Address
- Contact