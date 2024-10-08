1. If we are inserting random words or word lists (where each word list contains many words, and these words
   in the word list may be sorted), we should use a Trie without Parent Pointers
2. The main advantage of using a Trie with parent pointers is that if we are inserting sorted words in a word
   list such as a dictionary (that contains sorted words), we would do not have to start from the root and
   traverse the trie for each word. Consider 3 words: a. abcd b. abce c. abc
   a. In this case, when we insert word - "abcd", say we are at node "x" which contains "abcd"
   b. When we want to insert word - "abce", we can retract from node "x" to node "y" where y = x.parent.
   In this use case, value at node "y" will be - "abc"
   c. We can insert a new node in trie with value - "e", and update "y" (x's parent) with "e" as children key
   node('y').children['e'] = new_node
   d. If we had used a Trie without Parent Pointers, we would have to start from "root" to insert word - 'abcd',
   and search each node for 'a', 'b', 'c' in its children as keys, finally we would land at node 'y' which\
    would contain "c", Here we would find that it does not have a key 'e' in its children, We would create
   a new node with 'e' as key
   noe('y').children['e'] = new_node
   => This would require us to start from root of Trie and traverse trie for 3 nodes until we reach the node
   which contains the word or insert characters which are not present in Trie
   => For larger words, this traversal length would increase
   => If we were inserting "n" words, each of length 'm', we would have to traverse the Trie -
   [n * O(m)] times
   => Many of the traversals listed above can be eliminated by using Parent Pointers
3. Search for a word in both the tries
   a. Trie with Parent Pointers
   b. Trie without Parent Pointers
   is Exactly The SAME
4. Trie Without Parent Pointers:
   a. Word Lists (Random Words, Not Sorted words, Sorted words but not like in dictionary)
   b. Many Word Lists each of type listed in 'a'
5. Trie With Parent Pointers:
   a. Dictionary of words - Sorted Lexicographically
   b. Many Word Lists each from the dictionary in sorted order (sorted Lexicographically) and not Random
   Collection of Sorted Words
6. TrieNode For Autocomplete System:
   a. Prefix
   b. Top k words
   c. children (Hash which contains pointers for each character children to other TrieNodes)
7. If we want, we can reduce Memory Footprint further by NOT Storing the prefix on each node traversal in trie
   as prefix at node, it is possible.
   a. We can avoid storing prefix on node by using stack which is initialized to an empty string
   b. At each node, we push the current character of word in the stack
   c. If we are searching, we can calculate the prefix on the end node or the word at the end node by joining
   all the elements in stack with an empty string
   d. If we are inserting, we can backtrack to parent pointers by popping elements from stack at each backtrack
   step.
8. Autocomplete System - Google Type Search with Terms: WE SHOULD NOT STORE PREFIXES ON NODES
   a. If we do not store prefix as the prefix for a node,
   b. 1 billion requests per day
   c. Each request = 1 search term = 20 characters = 20 bytes
   d. Each search term = 20 prefixes
   e. Each prefix = Max Length of Characters = 20 = 20 bytes
   f. For 20 character prefix, we would store (1, 2, 3, 4, 5, 6, 7, ....., 20) character Prefixes
   g. Combinatorial Problem = 1 + 2 + 3 + 4 + 5 +....+ n = O(n^2) = n _ (n + 1) / 2
   h. 20 character prefix = 210 characters stored = 210 bytes
   i. 1 billion search terms = 1 billion _ 20 prefixes for each search term = 1 billion \* (210 bytes)
   = 210 billion bytes ~ 200 billion bytes = 200 GB
   f. We can save 200 GB if we do not store Prefixes in the Trie
9. Autocomplete System - Word Completion on Client Devices: SHOULD NOT STORE PREFIXES ON NODES. Same thing as (8) APPLIES TO
   a. Autocomplete for words but WHY?
   b. Total # = 200k words
   c. Each word = Max 10 characters = Max 10 Prefixes
   d. Each prefix = Max 10 characters
   e. Total characters of prefix stored = # of words _ # of Prefixes for each word _ # of chars for each Prefix
   = 200k _ 10 _ 10 = 2 _ (10^5) _ 10 _ 10 = 2 _ (10^7) = 2 _ 10 _ (10^6) = 20 \* (10^6) bytes
   = 20 million bytes = 20 MB
   f. 20 MB space on a client device such as IPhone, etc is NO SAVING of SPACE, since most such devices have
   storage in GBs
   g. Autocomplete system will be slowed down due to stack operations on each step for creating prefix
