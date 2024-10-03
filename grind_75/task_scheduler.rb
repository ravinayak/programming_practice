# You are given an array of CPU tasks, each labeled with a letter
# from A to Z, and a number n. Each CPU interval can be idle or allow
# the completion of one task. Tasks can be completed in any order, but
# there's a constraint: there has to be a gap of at least n intervals
# between two tasks with the same label.

# Return the minimum number of CPU intervals required to complete all
# tasks.

 

# Example 1:

# Input: tasks = ["A","A","A","B","B","B"], n = 2
# Output: 8
# Explanation: A possible sequence is: A -> B -> idle -> A -> B -> idle -> A -> B.
# After completing task A, you must wait two intervals before doing A again.
# The same applies to task B. In the 3rd interval, neither A nor B can be done,
# so you idle. By the 4th interval, you can do A again as 2 intervals have passed.

# Example 2:
# Input: tasks = ["A","C","A","B","D","B"], n = 1
# Output: 6
# Explanation: A possible sequence is: A -> B -> C -> D -> A -> B.
# With a cooling interval of 1, you can repeat a task after just one other task.

# Example 3:
# Input: tasks = ["A","A","A", "B","B","B"], n = 3
# Output: 10
# Explanation: A possible sequence is: A -> B -> idle -> idle -> A -> B -> idle -> idle -> A -> B.

# There are only two types of tasks, A and B, which need to be separated by 3 intervals.
# This leads to idling twice between repetitions of these tasks.

# Algorithm: Task scheduler can be implemented using any of the 2 strategies:
# 1. Simpler Approach: Calculate the base length of task schedule where task with max_frequency
# is considered 1st with empty slots required for cooling off period. 
#   a. If all other tasks can be fit into these slots, this would be the minimum time needed
#   to complete all the tasks
#   b. If all other tasks cannot be fit into these slots, we can always arrange tasks in a way
#   where they satisfy the cooling period. In this use case, tasks.size would be the minimum
#   time required to complete all tasks
#   Ex: tasks = ['A', 'A', 'A', 'B', 'B', 'B', 'C', 'C', 'D', 'D', 'E'], n = 3
#   Max Frequency of any task = 3 [= A, B]
#    => 1. A___A___A => Length = 1 + 3 + 1 + 3 + 1 = 3 * 1 + 3 * 2 = (gaps) * (n + 1)
#    => 2. gaps = max_frequency - 1, For 3 A's , we have 2 gaps
#    => 3. Each gap has length = cooling period required before we can process A again = n
#    => 4. Each gap also has an additional 1 time period for processing task with max frequency
#    => 5. Time consumed by 1 gap = 1 gap length (= "n") + 1 unit time to process task, 
#    => 6. Num of tasks = num of gaps + 1, for each gap time consumed increases by 1 for task
#    =>    included in the gap. At the end of considering all gaps, 1 task is left
#    => 7. Total time for gaps = gaps * (n + 1) + 1 = (max_frequency - 1) * (n + 1) + 1
#    => 8. If there are max_count number of tasks with max_frequency, each one of them will be
#          appended to end of task which we considered with max_frequency (= say 'A')
#    => 9. Step 8 is meaningful only if all the tasks fit into these slots
#    => 10. ABCDABCDABE is 1 such arrangement, here all the tasks do not fit into the slots,
#           hence tasks.size = Minimum time needed
#    => 11. If n = 4, A____A____A => ABCDEABCD_AB => All tasks fit into the empty slots
#           4th slot is empty because all other tasks have been processed, and both "A", and "B"
#           must have cooling period of "4" before they can be processed again. If we process "B",
#           in the empty slot, it would be only "2" units of cooling and hence we cannot process it.
#    => 12. All tasks with max_frequency must be processed in empty slots only once and be appended
#           to the end of the task we have considered for calculating gaps
#           => base_time = gaps * (n + 1) + 1 (task A will be processed once more than gap) + 
#           => remaining tasks (other than A with max_frequency) will also be processed
#           => at the end = max_count - 1
#           => base_length = (max_frequency - 1) * (n + 1) + 1 + (max_count - 1)
#           => base_length = (max_frequency - 1) * (n + 1) + 1 + max_count - 1
#           => base_length = (max_frequency - 1) * (n + 1) + max_count
#     => 13. From above, we can easily calculate
#           It is counter intuitive that we are using max instead of min to calculate the minimum
#           time intervals needed. base_length is the minimum time needed to process tasks with
#           max_frequency (as long as those tasks fit into the slots),
#           a. If they do not fit into the slots, we can always append them to the end
#           b. base_length is Required Time Interval, even if tasks.size is less, still this
#              amount of time is needed to process tasks with max_frequency
#           c. If tasks.size is > base_length, we need more time to process all the tasks
#           d. Hence we take "max"
#              min_time_interval = [tasks.size, base_length].max
#     => 14. Idle slots = [0, (base_length - tasks.size)].max
# @param [Array<String>] tasks
# @param [Integer] n
# @return [Array<Integer, Integer>] [time_to_complete, idle_slots]
def task_scheduler(tasks:, n:)

end

# @param [Array<String>] tasks
# @param [Integer] n
# @return [Array<Integer, Integer>] [time_to_complete, idle_slots]
def task_scheduler_using_pq(tasks:, n:)

end