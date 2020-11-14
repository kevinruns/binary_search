
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

  attr_accessor :value, :left, :right

  def initialize(value, left, right)
    @value = value
    @left = left
    @right = right
  end
end

# binary search tree
class Tree
  def initialize
    @root = nil
  end

  def build_tree(array, first, last)
    return nil if last < first

    mid = (first + last) / 2
    left_tree = build_tree(array, first, mid - 1)
    right_tree = build_tree(array, mid + 1, last)
    @root = Node.new(array[mid], left_tree, right_tree)
  end

  def insert(value)
    node = @root

    while node
      if value < node.value
        return node.left = Node.new(value, nil, nil) unless node.left

        node = node.left
      else
        return node.right = Node.new(value, nil, nil) unless node.right

        node = node.right
      end
    end
  end

  def del_successor(node)
    value = nil
    if node.right.left.nil?
      value = node.right.value
      node.right = node.right.right
    else
      parent = node.right
      while parent.left.left
        parent = parent.left
      end
      value = parent.left.value
      parent.left = nil
    end
    value
  end


  def delete(value)
    node = @root

    while node

      if value < node.value && node.left
        if node.left.value == value && !(node.left.left || node.left.left) 
            node.left = nil
            return
          else
            node = node.left
          end

      elsif value > node.value && node.right
        if node.right.value == value && !(node.right.right || node.right.left) 
          node.right = nil
          return
        else
          node = node.right
        end

      elsif value == node.value
        if node.left && node.right
          node.value = del_successor(node)
        elsif node.left
          node.value = node.left.value
          node.left = node.left.left
        elsif node.right
          node.value = node.right.value
          node.right = node.right.right
        end
        return

      else
        print "Value not found"
      end
    end
  end




  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

#array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array = [1,3,4,6,7,8,10,13,14]
sorted_array = array.sort.uniq

bst = Tree.new
bst.build_tree(sorted_array, 0, sorted_array.length - 1)
#bst.pretty_print
bst.insert(5)
bst.insert(11)
bst.insert(18)
bst.pretty_print
bst.delete(7)
bst.pretty_print
bst.delete(5)
bst.pretty_print
bst.delete(13)
bst.pretty_print