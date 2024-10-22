import requests
from bs4 import BeautifulSoup
import pandas as pd

def scrape_ngos(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    data = []
    
    ngos_section = soup.find_all('div', class_='ngo-list')
    
    for ngo in ngos_section:
        name = ngo.find('h2').text.strip()
        address = ngo.find('p', class_='address').text.strip()
        contact = ngo.find('p', class_='contact').text.strip()
        data.append([name, address, contact])
    
    return data

url = 'https://makenewlife.in/'

ngo_data = scrape_ngos(url)

df = pd.DataFrame(ngo_data, columns=['NGO Name', 'Address', 'Contact'])

df.to_csv('ngos_pune.csv', index=False)

print("NGO data scraping completed and saved to ngos_pune.csv.")
