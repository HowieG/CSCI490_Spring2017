# from lxml import html
# import requests

# # Sourced from http://docs.python-guide.org/en/latest/scenarios/scrape/#lxml-and-requests
# # page = requests.get('http://econpy.pythonanywhere.com/ex/001.html')
# page = requests.get('http://data1.cde.ca.gov/dataquest/CourseReports/CourseResults.aspx?Filter=A&TheYear=2014-15&cTopic=Course&cChoice=CrseEnroll&cLevel=School&cdscode=19647331932920&Subject=Y&AP=Y&IB=Y')
# tree = html.fromstring(page.content)
# print(tree)



from bs4 import BeautifulSoup
import requests

# Create a variable with the url
url = 'http://data1.cde.ca.gov/dataquest/CourseReports/CourseResults.aspx?Filter=A&TheYear=2014-15&cTopic=Course&cChoice=CrseEnroll&cLevel=School&cdscode=19647331932920&Subject=Y&AP=Y&IB=N&CTE=Y&lNotAll=True'

# Use requests to get the contents
r = requests.get(url)

# Get the text of the contents
html_content = r.text

soup = BeautifulSoup(html_content, 'html.parser')

print(soup.prettify())

# soup.body.findAll(text=re.compile('^No$'))




