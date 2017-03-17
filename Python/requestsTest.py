from lxml import html
import requests

# Sourced from http://docs.python-guide.org/en/latest/scenarios/scrape/#lxml-and-requests
# page = requests.get('http://econpy.pythonanywhere.com/ex/001.html')
page = requests.get('https://classes.usc.edu/term-20171/')
tree = html.fromstring(page.content)

# buyers = tree.xpath('//div[@title="buyer-name"]/text()')
# prices = tree.xpath('//span[@class="item-price"]/text()')
# print('Buyers: ', buyers)
# print('Prices: ', prices)

courses = tree.xpath('//*[@id="sortable-classes"]/li')
num_courses = len(courses)
print(len(courses))

for i in range(1,num_courses):
	course = tree.xpath('//*[@id="sortable-classes"]/li[' + str(i) + ']/a/text()')
	print(course[0])

	//*[@id="loyolahs/fYPO4q29nnj63brjfmitarhiesi5us"]/ul/li[7]/span/a


# Sourced from https://automatetheboringstuff.com/chapter11/
# res = requests.get('https://automatetheboringstuff.com/files/rj.txt')
# print(res.text[:250])