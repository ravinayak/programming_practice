# frozen_string_literal: true

# Implementation of Trie with Parent Pointers, the theory of when we
# should use such a Trie is explained in
# concepts_summary/trie_with_without_parent_pointers markdwon file

# Class for TrieNodeWithParent
class TrieNodeWithParent
  attr_accessor :parent, :value, :children

  def initialize
    @parent = nil
    @value = []
    # children should not be initialized to a hash using this block
    # Hash.new { |h, k| h[k] = nil }, in this form of initialization
    # whenever we check node.children[prefix_char].nil?, the code
    # block automatically inserts prefix_char into the children hash
    # and returns nil. We don't want to insert any key into hash
    # unless we explicitly set it in code
    @children = {}
  end
end

# class for implementation of TrieNode with Parent Pointers
class TrieWithParentPointers
  # curr_trie_node => Stores reference to the current trie node
  # that contains character which was searched by user
  # curr_trie_index => This is important so that we can continue
  # searching with the algorithm of checking deeper levels in Trie
  attr_accessor :root, :curr_trie_node, :curr_trie_index

  def initialize
    @root = TrieNodeWithParent.new
    @curr_trie_index = nil
    @curr_trie_node = nil
  end

  # Insert words from a sorted word list that satisfy the following
  # 2 properties
  # 1. Individual words in word_list are sorted
  #   a. Lexicographically
  #   b. 2nd sorting criterion is Length
  # 2. All word lists contain words arranged in proper order such
  # as in a dictionary. Core Idea here is that all search terms
  # and words cannot be loaded at once in memory due to size
  # and hence we load a certain number of words/search_terms
  # from the dictionary in word_list, process it, then process
  # another list of words from the dictionary. We process words
  # from the dictionary in batches, next batch contains words
  # starting from index: last word + 1, where
  #   a. last word = index of last word which was fetched in previous batch
  def insert(word_list_with_data:)
    # Initialize index for trie data structure to 0 so we can start inserting
    # from the root of Trie
    trie_index = 0
    trie_index_hsh = { trie_index: }
    # We will use Stack data structure, so we can insert characters found in
    # trie data structure during traversal, and if we are backtracking, we can
    # pop these characters from the stack until we have a stack which contains
    # only the characters relevant for the node to which the trie_index points
    # Initialize stack with '', so that we can have the value for root element
    # as ''
    prefix_stack = ['']
    # Initialize node to root of Trie Node
    node = root

    word_list_with_data.each do |word_with_data|
      # Iterate over characters of word to check if they exist in the trie
      # data structure and insert the character at correct position in the trie
      word = word_with_data[0]
      data = word_with_data[1]
      start_index = trie_index_hsh[:trie_index]
      # start_index should point to the same node which contains key for last
      # character in word
      # 0 => 0th char, 1 => 1st char, 2 => 2nd char
      # word.length = 2 => last char is at index word.length - 1
      # We must backtrack to this position in the Trie data structure
      # (start_index...word.length) will not execute if start_index = word.length
      # It will only execute if start_index < word.length since in range operator
      # we exclude char at word.length, word only contains characters from
      # 0 through word.length - 1
      while start_index > word.length - 1
        # Backtrack to earlier nodes
        node = bactrack_in_trie(node:, trie_index_hsh:, prefix_stack:)
        start_index -= 1
      end
      (start_index...word.length).each do |index|
        word_char = word[index]
        data_hsh = { word_char:, word:, data:, word_len: word.length, trie_index_hsh:, index: }
        node = insert_util(node:, data_hsh:, prefix_stack:)
      end
    end
  end

  def search(prefix:, new_search_flag: true)
    # Stateful servers will maintain the curr_trie_node and curr_trie_index for the
    # last character searched by user in a single search where user is typing
    # many characters in the Search in one try. Load Balancer will tell the client
    # which web server (partitioned on search term) to connect to, and the client
    # will establish Websocket connection with the web server and send characters
    # to the server.
    # Server will contain many processes which are applications which will have these
    # instances of Trie Node running on them. When the next request comes to server
    # in a limited time window, it is from the Same Search from User and hence
    # in this case the application will persist "curr_trie_index", "curr_trie_node"
    # values in a Distributed Redis Cache, and retrieve these values to continue
    # searching from where it left off last. This will ensure that Search in Trie by
    # User is amortized O(1) time complexity
    if new_search_flag
      # New Search will start at root with curr_trie_index set to 0
      @curr_trie_index = 0
      @curr_trie_node = root

      # Initialize node, prefix_stack
      node = root
      prefix_stack = ['']
      data = nil

      prefix.chars.each_with_index do |prefix_char, index|
        if node.children[prefix_char].nil?
          # If we want we can insert this char if it is not present in Trie
          # For new characters being inserted into Trie, we shall not insert
          # any value for the character until we reach the end character, intermediate
          # nodes holding characters will not have any value assigned to them. 1st node
          # to which we backtrack will have the data we want to store at the end of the
          # new word, we cache the data, if it is present, we use it else we use node.value
          data = data || node.value || 1
          trie_index_hsh = { trie_index: index }
          word_len = prefix.length
          data_hsh = { word: prefix, word_char: prefix_char, data:, word_len:, index:, trie_index_hsh: }
          node = insert_util(node:, data_hsh:, prefix_stack:)
        else
          node = node.children[prefix_char]
          @curr_trie_node = node
          @curr_trie_index += 1
          prefix_stack.push(prefix_char)
        end
      end
      # Return node.value
      node.nil? ? [] : node.value
    else
      # Fetch values from Redis cache, here initialize to some dummy values
      # and return the value for the next node
      # @curr_trie_node = redis.get('<web_server_name>:<process_id>:<user_id>:<ip_address>:curr_trie_node')
      # @curr_trie_index = redis.get('<web_server_name>:<process_id>:<user_id>:<ip_address>:curr_trie_index')
      # @curr_trie_node = @curr_trie_node.children[prefix.last]
      # @curr_trie_index += 1
      # return @curr_trie_node.value unless @curr_trie_node.nil?

      # This is a new character from the word which we could not find, hence we shall insert into trie
      # Value for this character can be:
      #    1. count of 1
      #    2. top k terms/words for the last found character, i.e. prev_trie_node or curr_trie_node.parent
      # word to be checked for insertion should span from 0th index to curr_trie_index which includes
      # the character that could not be found in Trie
      # word = prefix[0..curr_trie_index]

      # prefix_stack = ['']
      # Prefix stack should contain all the characters from 0 through curr_trie_index - 1, so that in
      # Match condition, we get true
      # when prefix_stack.join('') = word[0..trie_index]
      # (curr_trie_index - 1).times { |i| prefix_stack.push(word[i]) }

      # data = curr_trie_node.parent.value || 1
      # word_char = word[curr_trie_index]
      # trie_index_hsh = { trie_index: curr_trie_index - 1 }
      # index = word.length - 1
      # word_len = word.length
      # word_with_data_hsh = { word:, word_char:, data:, word_len:, index:, trie_index_hsh: }
      # node = curr_trie_node.parent
      # insert_util(node:, data_hsh:, prefix_stack:)
    end
  end

  private

  def insert_util(node:, data_hsh:, prefix_stack:)
    word, word_char, data, trie_index_hsh, word_len, index =
      data_hsh.values_at(:word, :word_char, :data, :trie_index_hsh, :word_len, :index)
    trie_index = trie_index_hsh[:trie_index]
    # Condition:
    # a. trie_index < word_len (generally word.length), if we are at
    # deeper level in Trie data structure where trie_index > word.length,
    # we should backtrack to the node in Trie where we can search for the
    # next character in word
    #  => trie_index < word.length ["=" sign SHOULD NOT BE USED]
    #  => If we are at root, we do not have any character stored in the
    #     root, hence trie_index = 0 => word[0...trie_index]
    #   1. No character from word should be matched because there is no
    #   prefix formed when we are at the root of trie root
    #   2. When trie_index = 1 => word[0...trie_index] = word[0..0]
    #   we match character at node 1 with word[0] since we are at the
    #   1st node in trie, prefix formed hence has length of 1
    #   3. To match, 'ab' => If we use trie_index <= word.length
    #   we shall have an issue when we Backtrack from deeper levels in
    #   the Trie.
    #   4. For the characters in word, we SHOULD IDEALLY SEARCH on the
    #   current node to determine if the char is present in children
    #   hash of node as "key"
    #     a. 'a'     => Root => trie_index = 0, word.length = 1
    #     b. 'ab'    => 1st Node => trie_index = 1, word.length = 2
    #     c. 'abc'  => 2nd Node => trie_index = 2, word.length = 3
    #   5. If we use trie_index <= word_len, we would stop at incorrect
    #   node when Backtracking and search in the children hash of this
    #   node for the character as "key", and perform WRONG INSERTIONS
    #     trie_index <= word.length => trie_index = 1
    #     a. 'a'  => 1st Node => We would search in 1st node if 1st node
    #     has 'a' in its children hash as "key", but we should be
    #     searching in the root node
    #  b. If the prefix formed by all the characters stored in Trie Nodes
    #  during traversal by concatenating them matches the prefix in
    #  word till the trie_index, we should search for the next character
    #  in word in Trie. Search if the current node contains an entry in its
    #  children hash for the character "word_char" as key
    #  c. current character - word_char is included in children hash of the
    #  current node as key
    #  d. Because this method will be called multiple times, we cannot check for
    #  root, since in subsequent calls to the method root of Trie Node will contain
    #  keys, and we must Recurse to the correct node B4 Insertion
    #  e. When we reach the last character in the word, we will store the data associated
    #  with the word as value for the node, this data can be:
    #   1. Simple Count of the Word
    #   2. Top k words for the word/search_term
    if trie_index < word_len && prefix_stack.join('') == word[0...trie_index] &&
       !node.children.key?(word_char)
      new_node = TrieNodeWithParent.new
      # new_node should have its parent point to current node, since this node is the
      # child of current node. Setup associations properly
      new_node.parent = node
      node.children[word_char] = new_node

      # Increment trie_index and push the current character onto stack. Increment
      # trie_index because we are going 1 level deeper in the Trie
      trie_index += 1
      trie_index_hsh[:trie_index] = trie_index
      prefix_stack.push(word_char)

      # If we have reached last character in word, we have the entire prefix represented
      # by new_node, hence we should store the data on this new_node, Data should NOT BE
      # stored on current_node because current_node does not reference the word_char, it
      # contains word_char as a key in its children hash. Node in Trie which represents
      # word_char is new_node
      new_node.value = data if index == word.length - 1
      # Set new_node to current node to continue searching for correct node to insert
      # character
      node = new_node
    else
      # Backtrack to earlier nodes
      node = bactrack_in_trie(node:, trie_index_hsh:, prefix_stack:)
    end

    # Return Node
    node
  end

  def bactrack_in_trie(node:, trie_index_hsh:, prefix_stack:)
    # Backtrack to earlier nodes
    node = node.parent

    # Decrement trie_index, since we are backtracking to an earlier node, prefix
    # formed by current set of characters obtained during traversal should not
    # include the current character, since we are going 1 level up
    trie_index_hsh[:trie_index] -= 1
    prefix_stack.pop

    # Return node
    node
  end
end

def word_list_with_data
  [
    ['a', %w[apple am ate]],
    ['at', %w[atnt atst atzt]],
    ['ate', %w[atexy atexz ateyz]],
    ['atef', %w[atefxy atefxz atefyz]],
    ['ab', %w[abxy abxz abyz]],
    ['abcd', %w[abcdxy abcdxz abcdyz]],
    ['b', %w[bxy bxz byz]],
    ['bcd', %w[bcdxy bcdxz bcdyz]],
    ['bcde', %w[bcdezy bcdexy bcdexz]]
  ]
end

def test
  trie_obj = TrieWithParentPointers.new
  trie_obj.insert(word_list_with_data:)
  search_res = trie_obj.search(prefix: 'bcde')
  print "\n\n Searching for bcde"
  print "\n Expected Search Result :: [\"bcdezy\", \"bcdexy\", \"bcdexz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'ab')
  print "\n Expected Search Result :: [\"abxy\", \"abxz\", \"abyz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'b')
  print "\n Expected Search Result :: [\"bxy\", \"bxz\", \"byz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'atef')
  print "\n Expected Search Result :: [\"atefxy\", \"atefxz\", \"atefyz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'atefg')
  print "\n Expected Search Result :: [\"atefxy\", \"atefxz\", \"atefyz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'atefg')
  print "\n Expected Search Result :: [\"atefxy\", \"atefxz\", \"atefyz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'f')
  print "\n Expected Search Result :: []"
  print "\n Res                    :: #{search_res.inspect}\n\n"
  search_res = trie_obj.search(prefix: 'btef')
  print "\n Expected Search Result :: [\"bxy\", \"bxz\", \"byz\"]"
  print "\n Res                    :: #{search_res.inspect}\n\n"
end

test
