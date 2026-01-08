from collections import defaultdict
from typing import List

def course_schedule(num_of_courses: List[int], pre_requisites: List[List[int]]):
	courses = [x for x in range(num_of_courses)]
	pre_reqs = defaultdict(lambda: [])

	for course, pre_req in pre_requisites:
		pre_reqs[course].append(pre_req)
    
	visited = set()
	cycle = set()
	result = []
  
	def dfs(course):
		if course in visited:
			return True
		visited.add(course)
		cycle.add(course)
		for pre_req_course in pre_reqs[course]:
			if pre_req_course in cycle:
				return False
			dfs(pre_req_course)
    
		cycle.remove(course)
		return True
  
	for course in courses:
		if not dfs(course):
			return []
	
	return list(visited)

print(course_schedule(num_of_courses = 4, pre_requisites = [[1,0],[2,0],[3,1],[3,2]]))
print(course_schedule(num_of_courses = 2, pre_requisites = [[1,0]]))
print(course_schedule(num_of_courses = 3, pre_requisites = [[0, 1],[1, 2], [2, 0]]))