require 'byebug'

class PolyTreeNode
  attr_accessor :children
  attr_reader :value, :parent

  def initialize(value)
    @value = value
    @children = []
    @parent = nil
  end

  def add_child(child)
    child.parent = self
  end

  def remove_child(child)
    raise "#{child} is not a child of #{self}" if child.parent == nil
    child.parent = nil
  end

  def parent=(parent_node)
    prior_parent = self.parent
    prior_parent.children.delete(self) if prior_parent
    @parent = parent_node
    if parent_node
      siblings = parent_node.children
      siblings << self unless siblings.include?(self)
    end
  end

  def dfs(target_value)
    return self if @value == target_value

    @children.each do |child|
      search_result = child.dfs(target_value)
      return search_result if search_result
    end

    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      queue += current_node.children unless current_node.children.empty?
    end
  end

end
