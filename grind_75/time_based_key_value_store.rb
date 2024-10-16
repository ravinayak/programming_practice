# frozen_string_literal: true

# Design a time-based key-value data structure that can store
# multiple values for the same key at different time stamps
# and retrieve the key's value at a certain timestamp.

# Implement the TimeMap class:

# TimeMap() Initializes the object of the data structure.
# void set(String key, String value, int timestamp) Stores
# the key key with the value - "value" at the given timestamp.
# String get(String key, int timestamp) Returns a value such
# that set was called previously, with timestamp_prev <= timestamp.
# If there are multiple such values, it returns the value associated
# with the largest timestamp_prev. If there are no values, it
# returns "".

# Example 1:
# Input
# ["TimeMap", "set", "get", "get", "set", "get", "get"]
# [
#   [], ["foo", "bar", 1], ["foo", 1], ["foo", 3],
#   ["foo", "bar2", 4], ["foo", 4], ["foo", 5]
# ]
# Output
# [null, null, "bar", "bar", null, "bar2", "bar2"]

# Explanation
# TimeMap timeMap = new TimeMap();
# // store the key "foo" and value "bar" along with timestamp = 1.
# timeMap.set("foo", "bar", 1);
#  // return "bar"
# timeMap.get("foo", 1);
# // return "bar", since there is no value corresponding to foo at
# // timestamp 3 and timestamp 2, then the only value is at timestamp 1 is "bar".
# timeMap.get("foo", 3);
# // store the key "foo" and value "bar2" along with timestamp = 4.
# timeMap.set("foo", "bar2", 4);
# // return "bar2"
# timeMap.get("foo", 4);
# // return "bar2"
# timeMap.get("foo", 5);

# Implements Time Based Key Value Store
# Supports Insert Operation in O(1)
# Supports Retrieve Operation in O(log n)
class TimeBasedKeyValStore
  attr_accessor :store

  def initialize
    @store = Hash.new { |h, k| h[k] = [] }
  end

  # Insert operation simply inserts key, val, timestamp
  # into store at specified key
  # Keys are inserted with val and timestamp in
  # chronological order of timestamp meaning they
  # are sorted in ascending order of increasing time
  def set(key:, val:, timestamp:)
    print "\n Stored #{val} at #{timestamp} \n"
    @store[key] << [timestamp, val]
  end

  # Algorithm: Main idea and complexity is in retrieval
  # of value for a specific key with the condition that
  # value retrieved for key for given timestamp "t" such
  #	that value is the value for timestamp <= t
  # Because a key can contain multiple values at different
  # timestamps, we want to retrieve the value at a
  # greatest timestamp <= t
  # All values for a key are present in the store for
  # given key in increasing order of time. We can easily
  # apply Modified Binary Search and find the value for
  # key at a timestamp <= t (greatest timestamp for all
  #	values stored for the key <= t)

  def get(target_key:, timestamp:)
    val = modified_binary_search(target_key:, timestamp:)
    print "\n Target Key :: #{target_key}, Timestamp :: #{timestamp}"
    puts "\n Value Retrieved :: #{val} \n"
  end

  private

  # When we search for the highest value less than a given
  # value (if it does not exist) in a sorted array (sorted
  # in ascending order), we initialize best_val = nil
  # We evaluate mid and allocate best to the highest value
  # in the sorted array which has a value less than the
  # target. This is because only the portion of array which
  # contains elements less than Target can contain the
  # greatest element <= Target
  # Portion of array which contains elements greater than
  # target >= target cannot contain the answer

  # @param [String] target_key
  def modified_binary_search(target_key:, timestamp:)
    values_timestamps_arr = @store[target_key]

    low = 0
    high = values_timestamps_arr.length - 1
    best_val = nil

    while low <= high

      mid = low + (high - low) / 2

      if values_timestamps_arr[mid][0] == timestamp
        return values_timestamps_arr[mid][1]
      elsif values_timestamps_arr[mid][0] < timestamp
        # Highest possible value less than Target will
        # be in this portion of the array which contains
        # entries of time < timestamp
        best_val = values_timestamps_arr[mid][1]
        low = mid + 1
      else
        high = mid - 1
      end
    end

    # Highest possible value for key at time <= timestamp
    best_val
  end
end

time_map = TimeBasedKeyValStore.new
time_map.set(key: 'foo', val: 'bar', timestamp: 1)
time_map.set(key: 'foo', val: 'bar2', timestamp: 4)
time_map.get(target_key: 'foo', timestamp: 1)
time_map.get(target_key: 'foo', timestamp: 3)
time_map.get(target_key: 'foo', timestamp: 4)
time_map.get(target_key: 'foo', timestamp: 5)
puts
