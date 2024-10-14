# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
# A transformation sequence from word beginWord to word endWord
# using a dictionary wordList is a sequence of words
# beginWord -> s1 -> s2 -> ... -> sk such that:

# Every adjacent pair of words differs by a single letter.
# Every si for 1 <= i <= k is in wordList. Note that beginWord
# does not need to be in wordList.
# sk == endWord
# Given two words, beginWord and endWord, and a dictionary wordList,
# return the number of words in the shortest transformation sequence
# from beginWord to endWord, or 0 if no such sequence exists.

# Example 1:
# Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
# Output: 5
# Explanation: One shortest transformation sequence is
# "hit" -> "hot" -> "dot" -> "dog" -> cog", which is 5 words long.

# Example 2:
# Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
# Output: 0
# Explanation: The endWord "cog" is not in wordList, therefore there is no valid
# transformation sequence.

# Algorithm: To create a word ladder, we have to find all the wo.rds which differ by one
# character from the transitioning_word.
# 1. For each word, in the word list, we prepare patterns where each character in the
# word is replaced by another character such as '#'
# 2. We find all possible patterns for the word by replacing each character in the word by
# the special character. We do this for all the words in the word list.
# 3. For each pattern, we store the pattern in an adjacency matrix where the key is pattern
# and the value is word. In this way, for all the patterns which are same, we store value
# for the pattern as an array of words from which the pattern was obtained
# 4. A pattern represents one character difference between the words which are stored in
# the adjacency matrix for that pattern. This allows us to choose from the words which
# have one character difference, so that we can find the next transitioning word
# 5. We continue this until we find the end_word
# 6. Since we want to find the shortest path from begin_word to end_word, we use Queue
# data structure which allows us to perform BFS, and the BFS allows us to find the
# shortest path from begin_word to end_word through a list of transitioning words
# 7. Because in a Queue, we perform level by level traversal, we are able to store and
# find the shortest path

def word_ladder(begin_word:, end_word:, word_list:)
  # Base Case: If the word list does not include end_word, there is no way we can
  # find a list of transitioning words from begin_word to end_word
  # Hence we return from the method
  return [nil, []] unless word_list.include?(end_word)

  word_list << begin_word unless word_list.include?(begin_word)

  # We initialize Hash such that all keys in the Hash are initialized to an empty
  # array by default
  adj_matrix = Hash.new { |h, k| h[k] = [] }
  # If a node has been processed, we mark it as visited
  visited = {}

  word_list.each do |word|
    (0...word.length).each do |index|
      # We form a pattern by considering all characters from 0 through index - 1,
      # replacing the character at index with '#' and including all characters
      # from index + 1 through end of word
      pattern = "#{word[0...index]}##{word[index + 1..]}"
      # Store word from which the pattern is formed
      adj_matrix[pattern] << word
    end
  end

  queue = Queue.new
  # We store the word, and the path taken from Transitioning from begin_word to
  # end_word as 2nd element in the array which will be Enqueued. Since we have
  # find list of words that can transition from begin_word to end_word, we enqueue
  # begin_word as the 1st element in queue
  queue_element = [begin_word, [begin_word]]
  queue.enqueue(data: queue_element)

  until queue.empty?
    current_word, path = queue.dequeue

    # If we have found current_word as end_word, we return tuple which contains
    # length of path, and actual path of transitioning words from begin_word
    # to end_word
    # Path includes end_word since it is the current_word and when we enqueue
    # any element, we include the word in path
    return [path.length, path] if current_word == end_word

    # If the current_word has already been processed, we skip the iteration
    next if visited[current_word]

    # We mark the node as visited since we are going to process it, and in the
    # adjacency matrix for patterns formed by this word, the word will appear
    # as a value for the key, which can cause cycles and waste of iterations
    visited[current_word] = true

    patterns = []
    # We form all possible patterns using current_word, and for each pattern
    # we find the words which map to the pattern
    (0...current_word.length).each do |index|
      patterns << "#{current_word[0...index]}##{current_word[index + 1..]}"
    end

    patterns.each do |pattern|
      adj_matrix[pattern].each do |neighbor|
        # If we have processed neighbor, we skip the iteration, the same
        # word can appear when we dequeue and also when we retrieve the
        # value for pattern from adjacency matrix
        next if visited[neighbor]

        # We append the current path and add neighbor to this path before
        # enqueuing it
        queue_element = [neighbor, path + [neighbor]]
        queue.enqueue(data: queue_element)
      end
      # Clear the adjacency matrix for pattern, so that if we find this pattern
      # again in iteration, we do not end up processing the same nodes again
      # and waste cycles
      adj_matrix[pattern] = []
    end
  end

  # We could not find the end_word through any transitioning words list
  [nil, []]
end

def input_arr
  [
    {
      begin_word: 'hit',
      end_word: 'cog',
      word_list: %w[hot dot dog lot log cog],
      output: [5, %w[hit hot dot dog cog]]
    },
    {
      begin_word: 'hit',
      end_word: 'cog',
      word_list: %w[hot dot dog lot log],
      output: [nil, []]
    },
    {
      begin_word: 'banas',
      end_word: 'fbmps',
      word_list: %w[fanas fbmps banana apple bat fbnas fbmas],
      output: [5, %w[banas fanas fbnas fbmas fbmps]]
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    begin_word = input_hsh[:begin_word]
    end_word = input_hsh[:end_word]
    path_length = input_hsh[:output][0]
    word_list = input_hsh[:output][1]
    res = word_ladder(begin_word:, end_word:, word_list:)
    print "\n Input - Begin word :: #{begin_word}, End word :: #{end_word}, Word List :: #{word_list.inspect}"
    print "\n Expected - Path Length :: #{path_length}, Word List :: #{word_list.inspect}"
    print "\n Result - Path Length   :: #{res[0]}, Word List :: #{res[1].inspect}\n"
  end
  print "\n"
end

test
