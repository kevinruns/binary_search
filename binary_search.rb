require 'pry'

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
    return "ERROR: #{value} already in tree" unless self.find(value) == false

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

  def delete(value)
    print "Deleting #{value}\n"
    node = @root

    # root case with no children
    node.value = nil if node.value == value && !node.children

    while node

      # for value less than node move left
      if value < node.value && node.left

        # but if left child == value and has no children need to delete link
        if node.left.value == value && !node.left.children
          node.left = nil
          return
        else
          node = node.left
        end

      # for value gt than node move right
      elsif value > node.value && node.right

        # but if right child == value and has no children need to delete link
        if node.right.value == value && !node.right.children
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
          node.left = node.right.left
          node.right = node.right.right
        end
        return

      else
        return "ERROR: Value not found"
      end
    end
  end

  def find(value)
    node = @root

    until node.value == value
      if value < node.value
        return false unless node.left

        node = node.left
      else
        return false unless node.right

        node = node.right
      end
    end
    node
  end

  # level order transverse
  def level_order()
    print "Level ordering\n"
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

    array = []
    queue_nodes.each { |node| array.push(node.value) }
    array
  end

  # in order transverse, return array of values
  def in_order(node=@root, array=[])
    return [node.value] unless node.children

    if node.left
      node.left.children ? in_order(node.left, array) : array.push(node.left.value)
    end

    array.push(node.value)

    if node.right
      node.right.children ? in_order(node.right, array) : array.push(node.right.value)
    end

    array
  end

  # pre order transverse, return array of values
  def pre_order(node=@root, array=[])
    return [node.value] unless node.children

    array.push(node.value)

    if node.left
      node.left.children ? pre_order(node.left, array) : array.push(node.left.value)
    end

    if node.right
      node.right.children ? pre_order(node.right, array) : array.push(node.right.value)
    end

    array
  end

  # post order transverse, return array of values
  def post_order(node=@root, array=[])
    return [node.value] unless node.children

    if node.left
      node.left.children ? post_order(node.left, array) : array.push(node.left.value)
    end

    if node.right
      node.right.children ? post_order(node.right, array) : array.push(node.right.value)
    end

    array.push(node.value)

    array
  end

  def height(node, cnt=0)
    return cnt unless node.children
    cnt += 1
    height(node.left, cnt) if node.left
    height(node.right, cnt) if node.right
  end

  def depth(node, dnode=@root, cnt=0)
    return cnt if node.value == dnode.value
    cnt += 1
    if node.value < dnode.value
      depth(node, dnode.left, cnt)
    else
      depth(node, dnode.right, cnt)
    end
  end

  def balanced?(node=@root, balance=true)

    return balance unless node.children

    left_height = node.left ? self.height(node.left) : nil
    right_height = node.right ? self.height(node.right) : nil
    balance = heights_balanced(left_height, right_height)

    balance = self.balanced?(node.left, balance) if node.left && node.left.children && balance
    balance = self.balanced?(node.right, balance) if node.right && node.right.children && balance
 
    balance
  end
  
  def heights_balanced(left, right)
    if left && right && ((left - right).abs <= 1)
      return true
    elsif (left.nil? && right == 0) || (left == 0 && right.nil?)
      return true
    elsif left.nil? && right.nil?
      return true
    else 
      return false
    end
  end

  def rebalance
    unless self.balanced?
      array = self.level_order
      self.build_tree(array, 0, array.length - 1)
      "Rebalanced"
    end
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

p bst.delete(9)
p bst.delete(23)
bst.pretty_print
p bst.balanced?
p bst.rebalance
bst.pretty_print
p bst.balanced?

# p bst.height(bst.find(67))
# p bst.depth(bst.find(5))
# bst.insert(5)
# bst.pretty_print
# bst.insert(11)
# bst.pretty_print
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
# p bst.in_order
# p bst.pre_order
# p bst.post_order