# frozen_string_literal: true

# You are given an array of non-overlapping intervals intervals
# where intervals[i] = [starti, endi] represent the start and
# the end of the ith interval and intervals is sorted in
# ascending order by starti. You are also given an interval
# newInterval = [start, end] that represents the start
# and end of another interval.

# Insert newInterval into intervals such that intervals is
# still sorted in ascending order by starti and intervals
# still does not have any overlapping intervals
# (merge overlapping intervals if necessary).

# Return intervals after the insertion.

# Note that you don't need to modify intervals
# in-place. You can make a new array and return it.

# Example 1:
# Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
# Output: [[1,5],[6,9]]

# Example 2:
# Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]],
#         newInterval = [4,8]
# Output: [[1,2],[3,10],[12,16]]
# Explanation:
# Because the new interval [4,8] overlaps with
#     [3,5],[6,7],[8,10].

# Key Idea: We have a sorted list of intervals where no
# interval overlaps with other. However, when we insert
# a new interval, there are 3 places where this interval
# can be inserted:
#  1. At the beginning of array
#  2. At middle between two intervals
#  3. At the end of array
# Only when an interval is inserted at the end, there is
# the possibility that the interval can overlap only with
# the last interval. Intervals at n-2, n-3 etc will not
# overlap with the newly inserted interval
# However, if interval is inserted at the beginning or in
# the middle, there is a possibility that the interval
# may overlap with other interval, which may overlap with
# other interval and so on. We really cannot say which
# intervals will overlap and which will not overlap
# Ex: [1, 100]
# intervals = [[1, 8], [10, 15], [18, 25], [28, 35]]
# If we insert this new interval into intervals array,
# it will overlap with every interval, resulting in only
# 1 interval in the intervals array
# merged_intervals = [[1,100]]
# => Typical algorithms of insertion where we iterate
#    over the itervals array to insert this new
#    interval will not work (or very complicated)

# Algorithm: The algorithm is simple, we use the same
# concept we used to merge intervals and find the
# intervals which do not overlap, merging intervals
# that overlap. The idea here is to look at only 2
# intervals at any time, new interval (to be added),
# and the current interval which is being processed in
# iteration. This will ensure that if any/all intervals
# in the intervals array are to be merged, they will be
# merged with the new interval one after the other.
# NOTE: KEY DIFFERENCE WITH MERGE INTERALS PROBLEM
# => Key difference with the merge intervals problem
# is that in the merge intervals problem, we compare
# the last interval in results (merged_intervals)
# array with the current interval being processed
# in iteration, BUT for this PROBLEM, we select
# new interval as the
# 1. interval which has not placed in results array
# 2. interval which has been merged with the current
#     interval being processed in iteration
# This interval is compared with the interval in
# iteration and processed again (with the 2 steps
# outlined before) until we reach the end

# There are 3 possibilities when we compare any 2
# intervals: a. interval_1 b. interval_2
# Visual Representation:
#
# interval 1 and interval 2 do not overlap or they
# overlap
# ------------------------------------------- (Number Line)
#        a. interval 1 ends before interval 2 starts
#     <-- interval 1 --->  <-- interval 2 -->
#        b. interval 2 ends before interval 1 starts
#     <-- interval 2 --->  <-- interval 1 -->
#       c. interval 1 and interval 2 overlap
#      <---------- merged interval ---------->
#
# If an interval does not overlap with another interval,
# and it ends before another interval begins, it should be
# pushed onto array, the other interval though can still
# overlap with the next interval in iteration and hence
# should not be inserted into array
# If two intervals overlap, we should merge them, but this
# merged interval should not be pushed onto array, because
# it cannot still overlap with the next interval in iteration
#
# 1. interval_1 ends before interval_2 starts. so
#    interval_1 should be put into array
#        => interval 1 is 1st in sorted order, push
#           it into array
#        => new interval = interval_2
# 2. interval_2 ends before interval_1 starts, so
#     interval_1 shoulg be put into array
#        => interval 2 is 1st in sorted order, push
#            it into array
#        => new interval = interval_1
# 3. interval_1 and interval_2 overlap, so we merge
#    the 2 intervals into a single interval
#        => We DO NOT MERGE THIS new interval into
#           results array because this could possibly
#           overlap with the next interval. Only those
#           intervals are pushed into array which do
#           not overlap, any interval which can possibly
#           overlap is not merged
#        => new interval = result of merge

# @param [Array<Array<Integer, Integer>>] intervals
# @param [<Array<Integer, Integer>] new_interval
# @return [Array<Array<Integer, Integer>>]
#
def insert_new_interval(intervals:, new_interval:)
  # intervals array is sorted in ascending order of
  # start_date
  index = 0
  len = intervals.length
  merged_intervals = []

  while index < len
    # 3 cases outlined here
    current_interval = intervals[index]
    # No Overlap condition:
    # 1. Current Interval ends before New Interval starts
    #    => Current Interval 1st in Sorted Order, then New Interval
    # 2. New Interval ends before Current Interval starts
    #   => New Interval 1st in Sorted Order, then Current Interval

    # These are not required but putting the values in
    # variable for conceptual clarity
    # We can use current_interval[0] etc directly in code but
    # using these variables for easier understanding

    start_time_curr_interval = current_interval[0]
    end_time_curr_interval = current_interval[1]
    start_time_new_interval = new_interval[0]
    end_time_new_interval = new_interval[1]
    # curr interval ends before new interval starts, hence
    # it is 1st in sorted order
    if end_time_curr_interval < start_time_new_interval
      # current interval is first in sorted order
      # hence it should be put into array
      merged_intervals << current_interval

    # new interval ends before curr interval starts, hence
    # new interval is 1st in Sorted Order
    elsif end_time_new_interval < start_time_curr_interval
      # same logic as before
      merged_intervals << new_interval
      # Assign new_interval to the interval which
      # is not in array and can overlap with the
      # next interval (sorting is the key)
      new_interval = current_interval

    # Overlap Condition: Else Clause of Overlap Condition which means
    # Overlap Condition = !Overlap Condition
    # 1st two if/elsif cover overlap conditions, else is Overlap Condition
    else
      # Overlapped interval will always have a length
      # which covers start/end times of both
      # interval_1 and interval_2
      # this new interval may overlap with the next
      # interval in iteration
      new_interval = [
        [start_time_curr_interval, start_time_new_interval].min,
        [end_time_curr_interval, end_time_new_interval].max
      ]
    end

    # Increment index
    index += 1
  end

  # Last iteration will produce a new interval which still needs
  # to be pushed into results array
  merged_intervals << new_interval

  # Return result
  merged_intervals
end

def test
  intervals_hsh_arr = [
    {
      intervals: [[1, 3], [6, 9]],
      new_interval: [2, 5],
      output: [[1, 5], [6, 9]]
    },
    {
      intervals: [[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]],
      new_interval: [4, 8],
      output: [[1, 2], [3, 10], [12, 16]]
    }
  ]

  intervals_hsh_arr.each do |interval_hsh|
    intervals = interval_hsh[:intervals]
    new_interval = interval_hsh[:new_interval]
    print "\nIntervals :: #{intervals}, "
    print "New Interval :: #{new_interval}\n"
    print "Expected :: #{interval_hsh[:output]}, "
    print "Result :: #{insert_new_interval(intervals:, new_interval:)} \n\n"
  end
end

test
