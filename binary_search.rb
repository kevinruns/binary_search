
# 1) Get the Middle of the array and make it root.
# 2) Recursively do same for left half and right half.
#       a) Get the middle of left half and make it left child of the root
#           created in step 1.
#       b) Get the middle of right half and make it right child of the
#           root created in step 1.


# code takes sorted array, start index, end index

# if start_index > end_index return null  (return when end -1 & start 0)
#     calculate middle (start + end / 2)
#     create root
#     call algo for left 
#     call for right


# binary search node
class Node

  attr_writer :left_child, :right_child

  def initialize(value, left_child, right_child)
    value = value
    left_child = left_child
    right_child = right_child
  end
end

# binary search tree
class Tree
  def initialize
    root = nil
  end

  def build_tree(array, first, last)

    mid = (first + last) / 2
#    p "mid: #{array[mid]}"

    return Node.new(array[first], nil, nil) if last < first

#   p "first #{first}  last #{last}"
    p array[first..last]
    p "call left first #{first}  mid-1 #{mid - 1}"
    left_tree = build_tree(array, first, mid - 1)
    p "call right  mid+1 #{mid + 1}  last #{last}"
    right_tree = build_tree(array, mid + 1, last)
    p "assign root with value #{array[mid]}"
    root = Node.new(array[mid], left_tree, right_tree)

  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
sorted_array = array.sort.uniq

bst = Tree.new
bst.build_tree(sorted_array, 0, sorted_array.length - 1)
