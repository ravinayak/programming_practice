# frozen_string_literal: true

require_relative '../algo_patterns/priority_queue/priority_queue_min_heap'
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
# @return [Hash] [time_to_complete, idle_slots]
def task_scheduler(tasks:, n:)
  # Produces a hash with key as task (element of array), and value for that key as the
  # frequency of occurrence of that element
  task_counts = tasks.tally

  max_frequency = task_counts.values.max
  max_count = task_counts.select { |_task, freq| freq == max_frequency }.length

  # Algorithmic way to determine the same values which have been calculated using
  # Ruby functions
  tc = Hash.new(0)
  max_freq = -1
  tasks.each do |task|
    tc[task] += 1
    max_freq = tc[task] if tc[task] > max_freq
  end
  m_count = 0
  tmp_hsh = {}
  tasks.each do |task|
    if !tmp_hsh.key?(task) && tc[task] == max_freq
      m_count += 1
      tmp_hsh[task] = true
    end
  end

  gaps = max_frequency - 1
  base_length_time_interval = gaps * (n + 1) + max_count

  idle_slots = [0, base_length_time_interval - tasks.size].max
  min_time_interval = [base_length_time_interval, tasks.size].max

  {
    min_time_interval:,
    idle_slots:
  }
end

# Algorithm: We can solve this problem using Priority Queue. In this use case, it does not matter
# whether we use Min Heap or Max Heap. We do not really care about the order in which elements are
# stored in the heap. They could be in any order. We care about the frequency of tasks and each task
# with its frequency should be inserted into the heap
# Since a cycle has "n" cooling period, essential length of time for cycle will be "n + 1", this is
# because cooling period can begin only when we perform a task, any task. This makes it "n + 1".
# In this time slot, we have to pick each element from Priority Queue, and process it. Any time the
# Priority Queue remains empty during a cycle, and more time intervals are left in the cycle, those
# time intervals will be empty slots / idle periods of CPU. These idle cycles should be added to the
# total_length_time_period

# @param [Array<String>] tasks
# @param [Integer] n
# @return [Array<Integer, Integer>] [time_to_complete, idle_slots]
def task_scheduler_using_pq(tasks:, n:)
  # Produces a hash with key as task (element of array), and value for that key as the
  # frequency of occurrence of that element
  task_counts = tasks.tally

  max_frequency = task_counts.values.max
  task_counts.select { |_task, freq| freq == max_frequency }.length

  pq = PriorityQueueMinHeap.new
  task_counts.each_pair do |task, task_count|
    # We persist the task along with its count, so we can print a possible sequence
    # of arrangement of tasks which can be completed in the minimum time interval
    # along with idle_slots number and minimum_time_interval required to complete
    # tasks
    obj_hsh = { task:, key: task_count }
    pq.insert_object(object: obj_hsh)
  end

  # Initialize variables for output
  task_sequence = ''
  min_time_interval = 0
  idle_slots = 0

  # Continue processing until pq becomes empty
  until pq.empty?
    # Initialize cycles = n+1, because for every task completed, we need "n" time
    # intervals for cooling off period.
    # In 1 cycle, we can process "n" tasks in "n" gaps, and before the start of
    # cool off period, we can process "1" task, so in 1 cycle, we can process
    # "n + 1" tasks, hence we initialize cycles = n + 1 so that we can process
    # "n + 1" tasks from the priority queue in one cycle
    # We decrement it in the while loop and hence it should be initialized so
    # that we can process "n + 1" tasks everytime
    cycles = n + 1
    # Declare temp array which will hold all the objects (tasks, count) when they
    # are extracted from pq after decrementing their count and validating that the
    # count > 0. Initialize it inside loop because it should be reset for every
    # execution of a cycle to hold tasks which have been extracted and whose count
    # has been decremented. It is used to populate pq once it becomes empty in a
    # cycle
    temp = []
    # Each cycle represents the time needed to process a task from priority queue
    # A cycle may have greater time and process all the tasks in pq when empty
    # idle slots will exist. It may be equal or less than the tasks in pq and in
    # such a case, no idle slots will exist, since tasks are remaining to be
    # processed in pq
    # We process by cycles as explained above because every task sequence requires
    # "n" cool off period in which we can process other tasks
    while cycles.positive? && !pq.empty?
      obj_hsh = pq.extract_min
      obj_hsh[:key] -= 1
      # If count of this task is > 0, we have to process this task again
      temp.push(obj_hsh) if (obj_hsh[:key]).positive?
      # Current task is being processed, so added to task sequence
      task_sequence += obj_hsh[:task].to_s
      # one time interval is needed to process the task, hence decremented by 1
      cycles -= 1
      min_time_interval += 1
    end

    # Re-insert a task from temp array into pq if its count > 0, since it needs
    # to be processed
    temp.each { |task_count_hsh| pq.insert_object(object: task_count_hsh) }

    # If pq became empty in the cycle, and no tasks remain, there is no need for
    # anymore cycles since all the tasks have been completed, we can break from
    # the loop as it will add time intervals which are not relevant
    break if pq.empty?

    # As long as cycles exist, current set of tasks in pq have been processed
    # This implies that these cycles will add to both the time interval and
    # idle_slots as idle times, task sequence will not contain any task to
    # be processed in this time interval
    while cycles.positive?
      cycles -= 1
      min_time_interval += 1
      idle_slots += 1
      task_sequence += '_'
    end

  end
  # Output
  {
    min_time_interval:,
    idle_slots:,
    task_sequence:
  }
end

def input_arr
  [
    {
      tasks: %w[A A A B B B],
      n: 2,
      output: 8
    },
    {
      tasks: %w[A C A B D B],
      n: 1,
      output: 6
    },
    {
      tasks: %w[A A A B B B],
      n: 3,
      output: 10
    },
    {
      tasks: %w[A A A B B B C C C D D E E F],
      n: 7,
      output: 10
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    tasks = input_hsh[:tasks]
    n = input_hsh[:n]
    output = input_hsh[:output]

    res = task_scheduler(tasks:, n:)
    res_with_task_seq = task_scheduler_using_pq(tasks:, n:)
    min_time_interval, idle_slots, task_sequence =
      res_with_task_seq.values_at(:min_time_interval, :idle_slots, :task_sequence)
    print "\n Tasks :: #{tasks.inspect}, n :: #{n}"
    print "\n Output :: #{output.inspect}"
    print "\n Res    :: #{res[:min_time_interval]}, Idle Slots :: #{res[:idle_slots]}"
    print "\n Res    :: #{min_time_interval}, Idle Slots :: #{idle_slots}, "
    print " task_sequence :: #{task_sequence} \n"
  end
end

test
