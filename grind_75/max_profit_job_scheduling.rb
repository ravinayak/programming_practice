# We have n jobs, where every job is scheduled to be done from
# startTime[i] to endTime[i], obtaining a profit of profit[i].

# You're given the startTime, endTime and profit arrays, return
# the maximum profit you can take such that there are no two jobs
# in the subset with overlapping time range.

# If you choose a job that ends at time X you will be able to start
# another job that starts at time X.

# Example 1:
# Input: startTime = [1,2,3,3], endTime = [3,4,5,6], profit = [50,10,40,70]
# Output: 120
# Explanation: The subset chosen is the first and fourth job.
# Time range [1-3]+[3-6] , we get profit of 120 = 50 + 70.

# Example 2:
# Input: startTime = [1,2,3,4,6], endTime = [3,5,10,6,9], profit = [20,20,100,70,60]
# Output: 150
# Explanation: The subset chosen is the first, fourth and fifth job.
# Profit obtained 150 = 20 + 70 + 60.

# Example 3:
# Input: startTime = [1,1,1], endTime = [2,3,4], profit = [5,6,4]
# Output: 6
# Algorithm:
# 1. We solve this problem using DP, where at each step, we make a choice whether to
# include current job or not to include current job
# 2. If we include current job, we have to find the last non-overlapping job to
# combine with the current job to maximize profits. We find the last non-overlapping
# job and not the job before this because there could be many jobs which we could miss
#   a. say current job is 'k'
#   b. last non overlapping job is "i"
#   c. 1 before last non overlapping job is "l"
#   d. dp[i] = Max Profits which can be incurred by including jobs from "0" to "i"
#   e. dp[l] = Max Profits which can be incurred by including jobs from "0" to "l"
#   f. l < i => If we combine dp[l] with currnt job, we shall end up missing many
#   jobs between "l" and "i" which could lower our profits
#   g. For the current job, we can only inlcude last non-overlapping job because
#   of job scheduling constraints
#   h. We must combine dp[i] with current job (dp[l] will reduce profits)
#   i. [dp[k - 1], current_job_profits + dp[i]].max
#   j. Since it is a DP array, we fill from 0 to jobs.length - 1
# 3. Combine all the inputs into a single array, and sort it on ascending order of
# end time for jobs so that we can non-overlapping jobs using Binary Search
# 4. This is a modified BinarySearch algorithm

def max_profits_job_scheduling(start_time:, end_time:, profits:)
  return 0 if start_time.empty? || end_time.empty? || profits.empty?

  return 0 if start_time.size != end_time.size || start_time.size != profits.size ||
              end_time.size != profits.size

  jobs = combine_arr_input(start_time:, end_time:, profits:)

  # Sort jobs in ascending order of end_time
  jobs.sort_by! { |job| job[1] }

  dp = Array.new(jobs.length, 0)
  # Initialize dp array with profit of jobs at index "0" and iterate from "1" to
  # jobs.length - 1
  dp[0] = [jobs[0][2], 0, -1]

  (1...jobs.length).each do |index|
    current_job_with_profits = jobs[index][2]
    last_non_overlapping_job_index = last_non_overlapping_using_binary_search(jobs:, i: index)
    current_job_with_profits += dp[last_non_overlapping_job_index][0] unless
      last_non_overlapping_job_index == -1
    # dp[index] = [current_job_with_profits, dp[index - 1]].max
    if current_job_with_profits > dp[index - 1][0]
      dp[index] = [current_job_with_profits, index, last_non_overlapping_job_index]
    else
      dp[index] = [dp[index - 1][0], index - 1, dp[index - 1][2]]
    end
  end
  # Return the value in last element of DP array which computes max profit for
  # all jobs from "0" through "jobs.length - 1"
  [dp[jobs.length - 1][0], select_max_profit_jobs(dp:, jobs:), jobs]
end

def select_max_profit_jobs(dp:, jobs:)
  index = dp.length - 1
  max_profts_jobs = []

  # The last job which can be selected can be at index 0 or it can be only the current
  # job in this iteration if we could not find any last non-overlapping job for the
  # current job, we store all the jobs which have been selected for the maximum profit
  # starting from dp.length - 1 until we reach 0 or the last non-overlapping job is -1
  while index >= 0
    job_indices = dp[index]
    max_profts_jobs << { job_index: job_indices[1], profit: jobs[job_indices[1]][2] }
    # If the last non-overlapping job index is -1, it means that only current job is
    # selected for max profits. In this case, we break from the loop since we have
    # found all the jobs with max profits
    break if job_indices[2] == -1

    # Current job selected for max_profit of all jobs may have a non overlapping index
    # which is not -1
    index = job_indices[2]
  end
  max_profts_jobs
end

def last_non_overlapping_using_binary_search(jobs:, i:)
  # Always start at index 0, high index is i-1 since we have to find non overlapping
  # jobs for current job, and index for current job is "i"
  low = 0
  high = i - 1

  while low <= high
    mid = low + (high - low) / 2

    # end time of job at mid index is <= start time of current job
    # => this job is non-overlapping
    if jobs[mid][1] <= jobs[i][0]
      # if end time of job at index "mid + 1" is <= start time of current job
      # it means all jobs from "0" to "mid" are to be ignored since jobs are
      # sorted in ascending order of end time, the last non-overlapping job
      # must be in "mid + 1" to "high"
      # mid + 1 <= high => Necessary for Index Bounds Check, mid + 1 > high
      if mid + 1 <= high && jobs[mid + 1][1] <= jobs[i][0]
        low = mid + 1
      else
        return mid
      end

    # mid + 1 > high OR jobs[mid + 1] has an end time which overlaps with current job
    # since job[mid] has the highest end time in "0" to "mid", hence
    # it must be the last non-overlapping job

    else
      # jobs[mid] has an end time which overlaps with current job, hence last
      # non-overlapping job must be between "0" to "mid - 1"
      high = mid - 1
    end
  end

  # If we could not find any last non-overlapping job for current job
  -1
end

def combine_arr_input(start_time:, end_time:, profits:)
  combined_arr = []
  start_time.each_with_index do |start_time_val, index|
    combined_arr << [start_time_val, end_time[index], profits[index]]
  end

  # Return combined_arr
  combined_arr
end

def input_arr
  [
    {
      start_time: [1, 2, 3, 3],
      end_time: [3, 4, 5, 6],
      profit: [50, 10, 40, 70],
      result: 120
    },
    {
      start_time: [1, 2, 3, 4, 6],
      end_time: [3, 5, 10, 6, 9],
      profit: [20, 20, 100, 70, 60],
      result: 150
    },
    {
      start_time: [1, 1, 1],
      end_time: [2, 3, 4],
      profit: [5, 6, 4],
      result: 6
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    start_time = input_hsh[:start_time]
    end_time = input_hsh[:end_time]
    profits = input_hsh[:profit]
    result = input_hsh[:result]

    res = max_profits_job_scheduling(start_time:, end_time:, profits:)
    print "\n\n Input Jobs sorted by their end time and profits:: #{res[2].inspect}"
    print "\n Expected Output :: #{result}"
    print "\n Total Profits   :: #{res[0]}"
    print "\n Jobs selected for Max Profits with their individual profts :: #{res[1].inspect}"
  end
  print "\n"
end

test
