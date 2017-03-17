#Sourced from
#http://chrisalbon.com/python/beautiful_soup_html_basics.html
#https://www.crummy.com/software/BeautifulSoup/bs4/doc/


from bs4 import BeautifulSoup
import requests

# Create a variable with the url
url = 'https://classes.usc.edu/term-20171/'

# Use requests to get the contents
r = requests.get(url)

# Get the text of the contents
html_content = r.text

soup = BeautifulSoup(html_content, 'html.parser')

# print(soup.prettify())

courses_data = soup.find_all(attrs={"data-type": "department"})

num_courses = len(courses_data)

departments = []

department_links = []

departments_map = []

for i in range(1,num_courses):
	#course_list_items.append(courses_data[i])
	department = courses_data[i].a.contents[0]
	department_link = courses_data[i].a.get('href')

	departments_map.append((department, department_link))


for a, b in departments_map:
	print(a  + ': ' + b)

num_departments = len(departments_map)

#links to follow
next_links = []

for j in range(1, num_departments):
	department = departments_map[j][0]
	if "computer" in department.lower():
		next_links.append(departments_map[j][1])
		print(departments_map[j][1]); 

#go to specified link
def jumpPages(url):

	# Use requests to get the contents
	r = requests.get(url)

	# Get the text of the contents
	html_content = r.text

	soup = BeautifulSoup(html_content, 'html.parser')

	#print(soup.prettify())



for k in range(0, len(next_links)):
	jumpPages(next_links[k-1])


# for child in range(1,num_courses):
	# print(courses_data[i].child)


# list_items = soup.find_all('li')

# num_li = len(list_items)

# for i in range(1, num_li):
# 	li = list_items[i]
# 	class_type = li['class']
# 	print(class_type)



# links = []

# test = list_items.children
# print(test)

# for i in range(1, num_li):
# 	for child in list_items[i]:
# 		# print(child)
# 		links.append(child)


# for child in links:
# 	print(child.string)