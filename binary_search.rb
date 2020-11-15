
# binary search node
class Node

  attr_accessor :value, :left, :right

  def initialize(value, left, right)
    @value = value
    @left = left
    @right = right
  end

  def children
    @left || @right ? true : false
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

  # insert a value
  def insert(value)
    print "Inserting #{value}\n"
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

  # for deleting nodes with 2 children, delete successor, return successor value
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

  # does node have children
  def children(node)
    node.left || node.right ? true : false
  end

  def delete(value)
    print "Deleting #{value}\n"
    node = @root

    # root case with no children
    node.value = nil if node.value == value && !children(node)

    while node

      # for value less than node move left
      if value < node.value && node.left

        # but if left child == value and has no children need to delete link
        if node.left.value == value && !children(node.left)
          node.left = nil
          return
        else
          node = node.left
        end

      # for value gt than node move right
      elsif value > node.value && node.right

        # but if right child == value and has no children need to delete link
        if node.right.value == value && !children(node.right) 
          node.right = nil
          return
        else
          node = node.right
        end

      # value found in node and node has children
      elsif value == node.value

        # case with 2 children, replace node value by successor, delete successor
        if node.left && node.right
          node.value = del_successor(node)

        # cases with one child, replace node by child
        elsif node.left
          node.value = node.left.value
          node.right = node.left.right
          node.left = node.left.left

        elsif node.right
          node.value = node.right.value
          node.right = node.right.right
          node.left = node.right.left
        end
        return

      else
        print "Value not found"
      end
    end
  end

  def find(value)
    print "Finding #{value}\n"
    node = @root

    until node.value == value
      if value < node.value
        return "Value not found" unless node.left

        node = node.left
      else
        return "Value not found" unless node.right

        node = node.right
      end
    end
    node
  end

  def level_order

    print "Level order output\n"
    queue_nodes = []
    queue_nodes.push(@root)
    next_level = []
    next_level.push(@root)

    until next_level.empty?
      i = 0
      next_level.each do |node|
        if node.left
          queue_nodes.push(node.left)
          i += 1
        end
        if node.right
          queue_nodes.push(node.right)
          i += 1
        end
      end
      next_level = queue_nodes.last(i)
    end

    queue_nodes.each do |node|
      p node.value
    end
  end


  def in_order(node = @root)

    return node.value unless children(node)

    if node.left
      if node.left.children
        in_order(node.left) 
      else 
        print "node #{node.left.value} \n"
      end
    end

    print "node #{node.value} \n"
    
    if node.right
      if children(node.right)
        in_order(node.right) 
      else 
        print "node #{node.right.value} \n"
      end
    end

  end

  def pre_order
    print "Pre-order traversal\n"

  end

  def post_order
    print "Post-order traversal\n"

  end


  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
#array = [1,3,4,6,7,8,10,13,14]
sorted_array = array.sort.uniq

bst = Tree.new
bst.build_tree(sorted_array, 0, sorted_array.length - 1)
bst.pretty_print
# bst.insert(5)
# bst.insert(11)
# bst.insert(18)
# bst.pretty_print
# bst.delete(7)
# bst.pretty_print
# bst.delete(5)
# bst.pretty_print
# bst.delete(13)
# bst.pretty_print
# bst.delete(1)
# bst.pretty_print
# bst.delete(14)
# bst.pretty_print
# bst.delete(18)
# bst.pretty_print
# p bst.find(10).value
bst.in_order