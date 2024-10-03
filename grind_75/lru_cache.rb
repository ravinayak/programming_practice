# frozen_string_literal: true

# Design a data structure that follows the constraints of a
# Least Recently Used (LRU) cache.

# Implement the LRUCache class:

# LRUCache(int capacity) Initialize the LRU cache with positive
# size capacity.
# int get(int key) Return the value of the key if the key exists,
# otherwise return -1.
# void put(int key, int value) Update the value of the key if the
# key exists. Otherwise, add the key-value pair to the cache. If
# the number of keys exceeds the capacity from this operation,
# evict the least recently used key.
# The functions get and put must each run in O(1) average time
# complexity.

# Example 1:

# Input
# ["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
# [[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
# Output
# [null, null, null, 1, null, -1, null, -1, 3, 4]

# Explanation
# LRUCache lRUCache = new LRUCache(2);
# lRUCache.put(1, 1); // cache is {1=1}
# lRUCache.put(2, 2); // cache is {1=1, 2=2}
# lRUCache.get(1);    // return 1
# lRUCache.put(3, 3); // LRU key was 2, evicts key 2, cache is {1=1, 3=3}
# lRUCache.get(2);    // returns -1 (not found)
# lRUCache.put(4, 4); // LRU key was 1, evicts key 1, cache is {4=4, 3=3}
# lRUCache.get(1);    // return -1 (not found)
# lRUCache.get(3);    // return 3
# lRUCache.get(4);    // return 4

# Algorithm: To implement LRU Cache, where get,put operations are O(1) time
# can be implemented using Hash Map. The main focus here is that that
# 1. cache has a limited capacity, and if we insert any key,value pair in
# the cache such that its capacity is exceeded, we should be able to remove
# the LRU item with the PUT operation in O(1) time.
# Implementation Strategy:
# 1. We use 2 different data structures, we create a hash map
# of doubly linked nodes, where each node represents key, value pair to be
# PUT into hash.
# 2. When we PUT any key into the hash, we move this node to the
# front of this doubly linked list. If the capacity is exceeded, we remove
# the node next to head, which is the least recently used element.
# 3. As we PUT (insert or update) any element, it is brought to the front of
# the doubly linked list.
# 4. Node which has been accessed least recently automatically becomes the node
# next to head. Hence we can easily remove this node from the list, and delete
# it from hash.
# 5. Moving to front / Deletion from head requires Pointer manipulation, and is
# O(1) time.
# 6. Deleting from hash also requires O(1) time.
# 7. Hence total time for PUT (insert or update) alongwith removal of least
# recently used node is O(1) time
# 8. Access from hash is O(1) time, hence all conditions of the problem are met

# Doubly Linked List Node with next, previous pointers
class DoublyLinkedListNode
  attr_accessor :next, :previous, :key, :value

  # @param [String] key
  # @param [String] value
  # Creates a node with key, value pairs without any linking to any list,
  # an isolated node
  def initialize(key:, value:)
    @key = key
    @value = value
    @next = nil
    @previous = nil
  end
end

# LRUCache implementation
class LRUCache
  MAX_CAPACITY = 100
  CACHE_MISS_VAL = -1

  attr_accessor :cache, :dll_head, :dll_tail, :capacity, :count

  # Setup cache to empty hash, setup head, tail of doubly linked list
  # head points to 1st node in list, it is the head of list i.e. beginning
  # tail points to last node in list through previous and its next to nil
  # To measure capacity, we keep count of items inserted into hash
  def initialize(capacity: MAX_CAPACITY)
    @cache = {}
    @dll_head = DoublyLinkedListNode.new(key: nil, value: nil)
    @dll_tail = DoublyLinkedListNode.new(key: nil, value: nil)
    @dll_head.next = @dll_tail
    @dll_tail.previous = @dll_head
    @capacity = capacity
    @count = 0
  end

  class << self
    # Apply the operations given in array input
    # @param [Array<String>] method_names
    # @param [Array<Array<Integer, Integer>>] data_input
    def apply_operations(method_names:, data_input:)
      class_name = Object.const_get(method_names[0])
      lru_cache = class_name.new(capacity: data_input[0][0])
      output = [nil]
      (1...method_names.length).each do |index|
        next unless !method_names[index].nil? && !data_input[index].nil?

        next if method_names[index] == 'put' && data_input[index].length < 2

        operation = method_names[index].to_sym
        output << lru_cache_operation(lru_cache:, operation:, data_input:, index:)
        print "\n Operation performed :: #{operation}, Data :: #{data_input[index].inspect}\n"
        lru_cache.display
      end

      # Return Output
      output
    end

    private

    # Apply operation and append output
    # @param [LRUCache] lru_cache
    # @param [Symbol] operation
    # @param [Integer] index
    # @param [Array<Array<Integer, Integer>>] data_input
    def lru_cache_operation(lru_cache:, operation:, data_input:, index:)
      return lru_cache.send(operation, key: data_input[index][0]) if
        operation == :get

      return unless operation == :put

      lru_cache.send(operation, key: data_input[index][0],
                                value: data_input[index][1])
    end
  end

  # Retrieve value for key from hash if it exists
  # @param [String] key
  # @return [String]
  def get(key:)
    node = @cache[key]
    return CACHE_MISS_VAL if node.nil?

    move_to_font(node:)
    # Return value of node
    node.value
  end

  # Insert or Update existing key in hash
  # @param [String] key
  # @param [String] value
  # @return [String | nil]
  def put(key:, value:)
    node = @cache[key]
    return insert_new_node(key:, value:) if node.nil?

    update_existing_node(key:, updated_value: value, node:)
  end

  # Displays each key, value pair in both cache and list
  def display
    print ' Cache key value pairs :: '
    @cache.each_pair do |key, node|
      print " Key :: #{key}, Value :: #{node.value}; "
    end
    list_display
  end

  private

  # Traverses doubly linked list and displays key, value
  # pair in each node
  def list_display
    print "\n List :: "
    node = @dll_head
    while node.next != @dll_tail
      node = node.next
      print " Key :: #{node.key}, Value :: #{node.value}; "
    end
    print "\n"
  end

  # Insert new node in hash and list
  # @param [String] key
  # @param [String] value
  # @return [String | nil]
  def insert_new_node(key:, value:)
    node = DoublyLinkedListNode.new(key:, value:)
    @count += 1
    assign_key_and_update_list(node:, key:)
    remove_lru_node if count > capacity

    # return nil
    nil
  end

  # Updates existing key to new value in node and
  # assigns this node to key in hash, and moves the
  # node to front of list
  # @param [String] key
  # @param [String] value
  # @param [DoublyLinkedListNode] node
  # @return [String | nil]
  def update_existing_node(key:, updated_value:, node:)
    node.value = updated_value
    assign_key_and_update_list(node:, key:)

    # return nil
    nil
  end

  # Helper method to assign node to key in hash and
  # move node to front of list
  # @param [String] key
  # @param [String] value
  # @param [DoublyLinkedListNode] node
  # @return [String | nil]
  def assign_key_and_update_list(node:, key:)
    @cache[key] = node
    move_to_font(node:)
  end

  # Removes least recently used Node from hash and list
  # @param [DoublyLinkedListNode] node
  # @return [String | nil]
  def remove_lru_node
    # Reset count to capacity, since we are removing
    # elements which have increased count such that
    # count > capacity
    # Removing capacity + 1 element should decrease
    # count to capacity
    @count = capacity
    # there is no node to remove
    return if @dll_head.next == @dll_tail

    # head.next = temp, here temp is the LRU node
    # Remove this node from the list and make it eligible
    # for garbage collection
    # delete this node from the cache
    temp = @dll_head.next
    @dll_head.next = temp.next
    temp.next.previous = @dll_head

    # delete node's key from cache
    @cache.delete(temp.key)

    # Make the temp node eligible for garbage collection
    garbage_collectible(node: temp)
  end

  # 4 use cases possible:
  # 1. Node being moved to front is a new node
  #     a. List is empty, this is the 1st node being inserted
  #     b. List is not empty, there are "count" nodes present
  # 2. Node being moved to front is an existing node in list
  #     a. Node is already in front
  #     b. Node is not in front of list
  # Moves node to front of list
  # @param [DoublyLinkedListNode] node
  # @return [nil]
  def move_to_font(node:)
    # Node is already the last node in the list, i.e at the
    # front of the list OR it is the head. If it is head,
    # this is an error case and should not have happened
    return if node.nil? || node.next == @dll_tail

    temp = node.previous
    current_mru_node = @dll_tail.previous

    # If this is a new node being moved to front of list
    # node.next and node.previous will both be nil
    # => temp is nil, there is no node whose pointers have
    # to be reset, hence none of the below 2 lines will be
    # executed
    temp.next = node.next if temp
    node.next.previous = temp if node.next && temp

    # Whether it is a new node being inserted into list
    # or an existing node in list whose value is being updated
    # or whose value is being retrieved, in both cases the
    # below lines will be executed
    # 1. Currently MRU node should point to this node
    # 2. Node previous should point to MRU node
    # 3. Node next should point to dll tail
    # 4. dll tail previous should point to node

    # Node which is at the front currently is the MRU node
    # This node should become previous of current node
    current_mru_node.next = node
    node.previous = current_mru_node

    # tail should point its previous to current node, and
    # current node should point to tail
    node.next = @dll_tail
    # Absolutely critical to set previous of tail to the node
    # which is moved to front. Tail will continue to point to
    # head and all the nodes which are supposed to move to
    # front will get inserted after head and directly point to
    # tail skipping other nodes which will become isolated nodes
    # Length of list in this case will always be 1 until we remove
    # an element. Unpredictable behaviour
    @dll_tail.previous = node
  end

  # Makes the node eligible for garbage collection by assigning
  # next/previous pointers of node to nil. Converts node to an
  # isolated node
  # @param [DoublyLinkedListNode] node
  # @return [nil]
  def garbage_collectible(node:)
    node.next = nil
    node.previous = nil
  end
end

def test
  method_names = %w[LRUCache put put get put get put get get get]
  data_input = [[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
  expected_ouput = [nil, nil, nil, 1, nil, -1, nil, -1, 3, 4]
  puts " Input :: #{data_input.inspect}"

  output = LRUCache.apply_operations(method_names:, data_input:)
  print "\n Input :: #{data_input.inspect}"
  print "\n Expected Output :: #{expected_ouput.inspect} \n"
  print " Output          :: #{output.inspect} \n\n"
end

test
