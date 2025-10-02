from collections import defaultdict, deque, Counter

# List Operations
def list_operations():
	l = list()

	l.append(1)
	print(l)

	l.append(2)
	print(l)

	l.append(3)
	print(l)

	l.insert(1, 4)
	print(l)

	l.append(5)
	l.append(6)
	print(l)

	l.pop()
	print(l)

	l.pop(1)
	print(l)

	l.remove(2)
	print(l)
	l.append(9)
	print(l)

	l.append(3)
	l.append(3)
	print(l)

	l.count(3)
	print(l.count(3))

	l.index(3)
	print(l.index(3))

	l.sort()
	print(l)

	l.reverse()
	print(l)

	l1 = [13, 19, 25]
	l.extend(l1)
	print(l)

# Set Operations
def set_operations():
    s = set()

    s.add(1)
    print(s)
    
    s.add(2)
    print(s)
    
    s.add(3)
    print(s)
    
    s.remove(2)
    print(s)
    
    s.add(4)
    s.add(5)
    s.add(6)
    print(s)
    
    s.remove(5)
    print(s)
    
    s.pop()
    print(s)
    
    s1 = { 3, 6, 7, 8, 9 }
    s2 = { 19, 6, 29, 39 }
    
    if 3 in s:
        print('3 exists in s')
    
    print(s.intersection(s1))
    print(s.union(s2))
    print(s.difference(s1))
    print(s.symmetric_difference(s1))

# Dictionary Operations
def dict_operations():
    d = dict()
    d1 = { 'str1': 100, 'str4': 250 }
    
    d['str1'] = 25
    d['str2'] = 50
    d['str3'] = 75
    
    if 'str1' in d:
        print('Key exists')
        
    print(d.keys())
    print(d.values())
    
    for key, val in d.items():
        print(f'Key :: {key}, Value :: {val}')
        
    print(d.get('str1'))
    print(d.get('str5', 0))
    
    d.update(d1)
    print(d)
    
    d.clear()
    print(d)
    
    d2 = defaultdict(lambda: 0)
    
    d2['str7'] = 275
    print(d2.get('str6'))
    print(d2['str6'])
    print(d2.get('str7'))

# String Operations
def str_operations():
    str = ' ab,cDeF '
    print(str.split(','))
    print(str.strip())
    
    str_arr = ['g', 'h', 'i']
    print(str.strip() + ''.join(str_arr))
    print(str.join(str_arr))
    
    print(str.lower())
    print(str.upper())
    
    print(str.isdigit())
    print(str.isalpha())
    print(str.isalnum())
    
    # No in place replacement of characters of a string, a new string is returned
    # with the characters replaced, original string remains intact
    print(str.replace('b,c', '12'))
    print(str)
    
    print(str.find('e'))
    print(str.find('z'))
    
    print(str.strip().startswith('a'))
    print(str.strip().endswith('F'))
	
# Tuples are immutable like strings and can be used as keys for a dictionary
# Tuples cannot be mutated, so they do not have any add/remove
def tuple_operations():
    t = (1, 2, 3, 5, 2, 2)
    print(t.index(3))
    print(t.count(2))
    
def counter_operations():
    l = [1, 2, 2, 3, 2, 3, 3, 3, 4, 4, 5, 2, 2, 2, 5]
    c = Counter(l)
    print(c)
    
    print(c.most_common(3))
    print(c.elements())
    c.subtract({2: 2})
    print(c)
    c.update({2: 6})
    print(c)

def deque_operations():
    d = deque()
    d.append(1)
    d.append(2)
    d.append(3)
    print(d)
    
    d.appendleft(5)
    d.appendleft(6)
    print(d)
    
    d.pop()
    print(d)
    
    d.popleft()
    print(d)
    
    d.extend([3, 4])
    print(d)
    
    # extendleft will iterate over elements in the given list and append them one by one
    # to the left of the existing deque
    # d = [5, 1, 2, 3, 4]
    # 19 will be added to the left 1st => [19, 5, 1, 2, 3, 4]
    # 39 will be added to the left next => [39, 19, 5, 1, 2, 3, 4]
    d.extendleft([19, 39])
    print(d)
    
def main():
    # list_operations()
    # set_operations()
    # dict_operations()
    # str_operations()
    # tuple_operations()
    # counter_operations()
    deque_operations()
    
main()