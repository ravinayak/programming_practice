# frozen_string_literal: true

require_relative '../algo_patterns/graphs/graph_algos_implementation/union_find'
# Given a list of accounts where each element accounts[i] is a list
# of strings, where the first element accounts[i][0] is a name, and
# the rest of the elements are emails representing emails of the account.

# Now, we would like to merge these accounts. Two accounts definitely
# belong to the same person if there is some common email to both accounts.
# Note that even if two accounts have the same name, they may belong to
# different people as people could have the same name. A person can have
# any number of accounts initially, but all of their accounts definitely
# have the same name.

# After merging the accounts, return the accounts in the following format:
# the first element of each account is the name, and the rest of the elements
# are emails in sorted order. The accounts themselves can be returned in
# any order.

# Example 1:
# Input: accounts =
# [
#   ["John","johnsmith@mail.com","john_newyork@mail.com"],
#   ["John","johnsmith@mail.com","john00@mail.com"],
#   ["Mary","mary@mail.com"],
#   ["John","johnnybravo@mail.com"]
# ]
# Output:
#   [
#     ["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],
#     ["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]
# ]
# Explanation:
# The first and second John's are the same person as they have the
# common email "johnsmith@mail.com".
# The third John and Mary are different people as none of their email
# addresses are used by other accounts.
# We could return these lists in any order, for example the answer
# [['Mary', 'mary@mail.com'], ['John', 'johnnybravo@mail.com'],
# ['John', 'john00@mail.com', 'john_newyork@mail.com', 'johnsmith@mail.com']]
# would still be accepted.

# Example 2:
# Input: accounts =
# [
#   ["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],
#   ["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],
#   ["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],
#   ["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],
#   ["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]
# ]
# Output:
# [
#   ["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],
#   ["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],
#   ["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],
#   ["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"],
#   ["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"]
# ]

# Algorithm: To solve this problem we use Union-Find data structure
# and union, find methods. For each different email, we allocate a
# unique id, and for all the emails that belong to the same name,
# we perform a union of those emails such that they are grouped
# under 1 root email id. If same email occurs in another person's
# name list, this email will automatically be found because a
# unique id is allocated to each email. All other emails for this
# person (name), will become subtrees of the other email's root id
# This will allow us to group all emails together if same email
# occurs in another person name's list. We also maintain a mapping
# for each email to name. We shall collect root ids for all emails
# and associate all the emails for that root id email together in
# a single array.
# 1. We map name, emails together for the emails that
# have been merged.
# 2. Emails that have NOT Been Merged, will form Disjoint sets and
# accounts for those names will not be merged

# We should not use name_email_hsh because it is possible that
# same/different people may have same names, and then the value
# for that name (as key) will be over-written by last account
# giving us incorrect results
# Iterate over accounts directly without an intermediate step
# of preparing name/emails hash

# @param [Array<String>] accounts
# @return [Array<String>]
def merge_accounts(accounts:)
  # Map emails to a unique id, since UnionFind uses Integers,
  # Map emails to name, so we can retrieve name associated
  # with root_id when we union them together
  # If persons with different/same names have a common email,
  # they shall be grouped under same root_id, and we shall
  # collect all emails under that root_id as representative
  # of merged account
  email_to_id = {}
  email_to_name = {}
  root_id_emails_map = Hash.new { |h, k| h[k] = [] }

  # UnionFind must be initialized with total length of emails,
  # since parent/rank needs to account for maximum possible
  # of id (which can be = total count of emails, if they are
  # all different)
  total_email_count = accounts.reduce(0) { |acc, account| acc + account.length - 1 }
  index = 0
  uf = UnionFind.new(size: total_email_count)

  # Iterate over each account_email array, extract name, emails from
  # the array, first_email.
  # Store id, name for each email, and union all emails that belong to
  # same name or if they belong to a different name, they should have
  # the same value to be unioned together in the same set
  # If any email is same, in
  # a. 1st time it is encountered, it will be grouped with a root_id
  #    under all other emails for that name
  # b. 2nd time it is encountered, all emails under that name will be
  #    grouped together with the same root_id found in Step a for that
  #    email.
  # c. Step a, Step b will ensure that if same email exists in different
  #    names, they will be grouped under same root_id
  accounts.each do |account_emails|
    name = account_emails[0]
    emails = account_emails[1..]
    first_email = emails[0]

    emails.each do |email|
      if email_to_id[email].nil?
        email_to_id[email] = index
        email_to_name[email] = name
        index += 1
      end
      uf.union(x: email_to_id[first_email], y: email_to_id[email])
    end
  end

  # For each email, we find the root_id for that email's id and store
  # email under root_id. This will grpup all accounts (merging them
  #	effectively) under one root_id.
  # Disjoint sets which do not have same email will be grouped under
  # different root_id
  email_to_id.each do |email, id|
    root_id = uf.find(x: id)
    root_id_emails_map[root_id] << email
  end

  merged_accounts = []
  # Extract name for any of the emails grouped under a root_id
  # Format the result as [name] + emails.sort because we want
  # sorted emails for a name
  root_id_emails_map.each_value do |emails|
    name = email_to_name[emails[0]]
    merged_accounts << [name] + emails.sort
  end

  merged_accounts
end

def accounts_one
  input_accounts = [
    ['Gabe', 'Gabe0@m.co', 'Gabe3@m.co', 'Gabe1@m.co'],
    ['Kevin', 'Kevin3@m.co', 'Kevin5@m.co', 'Kevin0@m.co'],
    ['Ethan', 'Ethan5@m.co', 'Ethan4@m.co', 'Ethan0@m.co'],
    ['Hanzo', 'Hanzo3@m.co', 'Hanzo1@m.co', 'Hanzo0@m.co'],
    ['Fern', 'Fern5@m.co', 'Fern1@m.co', 'Fern0@m.co']
  ]
  output = [
    ['Gabe', 'Gabe0@m.co', 'Gabe1@m.co', 'Gabe3@m.co'],
    ['Kevin', 'Kevin0@m.co', 'Kevin3@m.co', 'Kevin5@m.co'],
    ['Ethan', 'Ethan0@m.co', 'Ethan4@m.co', 'Ethan5@m.co'],
    ['Hanzo', 'Hanzo0@m.co', 'Hanzo1@m.co', 'Hanzo3@m.co'],
    ['Fern', 'Fern0@m.co', 'Fern1@m.co', 'Fern5@m.co']
  ]
  { input_accounts:, output: }
end

def accounts_two
  input_accounts = [
    ['John', 'johnsmith@mail.com', 'john_newyork@mail.com'],
    ['John', 'johnsmith@mail.com', 'john00@mail.com'],
    ['Mary', 'mary@mail.com'],
    ['John', 'johnnybravo@mail.com']
  ]
  output = [
    ['John', 'john00@mail.com', 'john_newyork@mail.com', 'johnsmith@mail.com'],
    ['Mary', 'mary@mail.com'], ['John', 'johnnybravo@mail.com']
  ]
  { input_accounts:, output: }
end

def test
  accounts_arr = [accounts_one, accounts_two]

  accounts_arr.each do |account_hsh|
    result = merge_accounts(accounts: account_hsh[:input_accounts])
    puts
    puts "Input Account :: #{account_hsh[:input_accounts].inspect}"
    puts "Output :: #{account_hsh[:output].inspect}"
    puts "Result :: #{result.inspect}"
    puts " Result same as output :: #{result == account_hsh[:output]}"
    puts
  end
end

test
