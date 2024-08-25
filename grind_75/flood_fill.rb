# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'

# Problem Statement:
# An image is represented by an m x n integer grid image where image[i][j]
# represents the pixel value of the image.

# You are also given three integers sr, sc, and color. You should perform a
# flood fill on the image starting from the pixel image[sr][sc].

# To perform a flood fill, consider the starting pixel, plus any pixels
# connected 4-directionally to the starting pixel of the same color as the
# starting pixel, plus any pixels connected 4-directionally to those pixels
# (also with the same color), and so on. Replace the color of all of the
# aforementioned pixels with color.

# Return the modified image after performing the flood fill.

# This is a variation of the FloodFill Algorithm. The Flood Fill
# algorithm is a method used to determine and change the area connected to
# a given node in a multi-dimensional array. It is commonly used in computer
# graphics to fill a contiguous region with a particular color, much like the
# "paint bucket" tool in many graphics editors.

# Approaches: BFS / DFS
# Time Complexity: O(m * n) where m,n are dimensions of the image. Algorithm
# must process each pixel at least once to determine if it should be changed

# Space Complexity: O(m * n), in the worst case we may have to store all
# pixels to explore

# BFS/DFS - Which approach is better?
# BFS is often preferred for the flood fill algorithm because it provides more
# predictable memory usage and avoids issues with deep recursion. However, DFS
# can be faster and simpler for smaller images or smaller fill areas.

# BFS:
#  a. More predictable Memory Usage => It uses an explicit stack/queue
#  b. Processes level by level => Better suited for large areas / areas that
#       spread evenly
# DFS:
#  a. Explores in 1 direction deeply => Suited for smaller areas with less spread
#  b. Can cause stack overflow errors => Deep Recursion

# In this solution, we use queue to hold those elements which need to be udpated
# for color. Unlike normal BFS of a tree where we would enqueue every node in the
# queue, we only enqueue those nodes which should be updated for color (since the
# problem statement specifies conditions for which cell can or cannot be updated)
# Once we process this element, we look at 4-directionally connected pixels
# horizontal/vertical adjacent cells to find the next element which needs to be
# updated for color. If the adjacent cell does satisfy the condition for update
# and has not already been updated, we enqueue it

# Implementation of Flood fill
# @param [Array<Array<Integer>>] image
# @param [Integer] sc (starting column)
# @param [Integer] sr (starting row)
# @param [String] color
# @return [Array<Array<Integer>>]
#
def flood_fill(image:, sr:, sc:, color:)
  queue = Queue.new
  # Go up/below in same column => Row changes / Col same => [-1, 0], [+1, 0]
  # Go left/right in same row => Col changes / Row same => [0, -1], [0, +1]
  # 4-directionally connected components => Horizontal/Vertical adjacent cells
  directions_arr = [[-1, 0], [+1, 0], [0, -1], [0, +1]]

  # Start at the pixel provided in input parameters
  queue.enqueue(data: [sr, sc, image[sr][sc]])

  # In a 2D array representation in Ruby, we use an array of arrays where
  # each element in array is also an array that holds values for col entries
  # ex: image = [[1, 1, 1], [1, 0, 1], [1, 1, 1], [1, 0, 0], [1, 1, 0]]
  # image has 5 rows and 3 cols
  # we can start filling this 2D grid from top-left by using elements from
  # array in increasing order of index
  #          Col 1   Col 2    Col 3    Array  Entry   Index in image
  # Row 1      1        1        1        [1, 1, 1]        0
  # Row 2      1       0        1         [1, 0, 1]        1
  # Row 3      1        1        1        [1, 1, 1]        2
  # Row 4      1        0        0        [1, 0, 0]        3
  # Row 5      1        1        0        [1, 1, 0]        4

  # a. number of rows = Size of Array
  # b. number of cols = Size of any element (say 1st) in array
  #    	= Size of 1st element = Size of 1st array
  row_length = image.length
  col_length = image[0].length

  # Until queue is empty, keep processing
  until queue.empty?

    element = queue.dequeue

    # De-construct row, col, original_color from array
    row, col, original_color = element

    # Update color of pixel if it has not been updated
    image[row][col] = color if original_color != color

    directions_arr.each do |dir|
      new_row = row + dir[0]
      new_col = col + dir[1]
      # While calculating new row, new col, index bounds must be checked
      # before accessing array element with that index
      next unless new_row >= 0 && new_row < row_length && new_col >= 0 && new_col < col_length
      # Queue only contains those pixels which should be processed for
      # updating color

      # 1. Color of this pixel should not already be updated
      # 2. Satisfies the condition given in problem statement for update
      next unless udpate_pixel_color?(color:, original_color:, pixel_color: image[new_row][new_col])

      queue.enqueue(data: [new_row, new_col, image[new_row][new_col]])
    end

  end

  # Return modified image
  image
end

# @param [String] color
# @param [String] original_color
# @param [String] pixel_color
# @return [Boolean]
#
def udpate_pixel_color?(color:, original_color:, pixel_color:)
  pixel_color != color && pixel_color == original_color
end

def test
  pixel_arr = [
    {
      image: [[1, 1, 1], [1, 1, 0], [1, 0, 1]],
      sr: 1,
      sc: 1,
      color: 2,
      output: [[2, 2, 2], [2, 2, 0], [2, 0, 1]]
    }
    # {
    #   image: [[0, 0, 0], [0, 0, 0]],
    #   sr: 0,
    #   sc: 0,
    #   color: 0,
    #   output: [[0, 0, 0], [0, 0, 0]]
    # }
  ]

  pixel_arr.each do |pixel_hsh|
    image = pixel_hsh[:image]
    sr = pixel_hsh[:sr]
    sc = pixel_hsh[:sc]
    color = pixel_hsh[:color]
    print "Input Elements :: #{image}, sr: #{sr}, "
    print "sc: #{sc}, color: #{color}\n"
    print "Output :: #{flood_fill(image:, sr:, sc:, color:)}"
    print ", Expected Output :: #{pixel_hsh[:output]} \n"
  end
end

test
