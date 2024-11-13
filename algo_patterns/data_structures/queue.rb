# Queue class implementation using arr, rear, front
class Queue
  attr_accessor :arr, :rear, :front

  # Front <=> Index in stack for display and peek
  # Rear <=> Index for initialization
  def initialize
    @arr = []
    @rear = -1
    @front = 0
  end

  def empty?
    rear < front
  end

  def enqueue(data:)
    @rear += 1
    @arr[rear] = data
  end

  def dequeue
    return nil if empty?

    element = element_at_front
    @front += 1
    element
  end

  def size
    # When empty? rear < front and rear - front + 1
    # will give correct answer, yet for Precautionary
    # measure, we return
    # Consider, rear = -1, front = 0 (Queue is empty)
    # rear - front + 1 = -1 -0 + 1 = 0
    #
    return 0 if empty?

    # Rear points to element which has been added to queue
    # front points to element which has still not been deleted,
    # every element b4 front has been deleted
    # rear - front = <front + 1, front + 2, front + 3,..., rear>
    # Add 1 to include element at front position
    rear - front + 1
  end

  def display
    return if empty?

    stack_front = front
    while stack_front <= rear
      print "#{arr[stack_front]} "
      stack_front += 1
    end
  end

  # Peek implies element at front of Queue, Queue is FIFO - First in First Out
  # First in => Front
  # Last in => Rear
  # Front <=> Index in stack for display and peek
  def peek
    element_at_front
  end

  def element_at_front
    arr[front]
  end
end

def test
  queue = Queue.new
  puts " Queue Empty :: #{queue.empty?}"
  puts " Queue Size :: #{queue.size}"
  queue.enqueue(data: 5)
  queue.enqueue(data: 6)
  queue.enqueue(data: 7)
  print ' Queue Elements being displayed :: '
  queue.display
  print "\n"
  puts " Queue Peek :: #{queue.peek}"
  puts " Queue Dequeued :: #{queue.dequeue}"
  puts " Queue Size :: #{queue.size}"
  puts " Queue Empty :: #{queue.empty?}"
  puts " Queue Dequeued :: #{queue.dequeue}"
  print ' Queue Elements being displayed :: '
  queue.display
  puts
  puts " Queue Dequeued :: #{queue.dequeue}"
  puts " Queue Empty :: #{queue.empty?}"
  puts " Queue Elements being displayed :: #{queue.display}"
end

test
