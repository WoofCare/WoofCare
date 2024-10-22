# WoofCare - Scrapper

This project contains a Python script that scrapes information about NGOs from a website using `BeautifulSoup` and `requests`, and saves the data into a CSV file.

Features

Scrapes NGO names, addresses, and contact information from the specified website.
Outputs the scraped data into a CSV file (`ngos_pune.csv`).

Requirements

To run this script, you need to have Python 3 installed along with the following Python libraries:

- `requests`
- `beautifulsoup4`
- `pandas`

You can install these dependencies by running:

```bash
pip install requests beautifulsoup4 pandas
```

How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ngo-data-scraper.git
   cd ngo-data-scraper
   ```

2. Edit the script to modify the URL from which you want to scrape NGO data if needed. The default URL is set to `https://makenewlife.in/`.

3. Run the script:
   ```bash
   python scrape_ngos.py
   ```

4. The script will scrape the data and save it to a CSV file named `ngos_pune.csv` in the root directory of the project.

Output

The output will be a CSV file with the following columns:

- NGO Name
- Address
- Contact

Example

Sample CSV structure:

| NGO Name        | Address                   | Contact          |
|-----------------|---------------------------|------------------|
| NGO Example 1   | 123 Street, Pune, India    | +91 9876543210   |
| NGO Example 2   | 456 Road, Pune, India      | +91 8765432109   |

