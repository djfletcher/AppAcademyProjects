require_relative '../skeleton/lib/00_tree_node'

class KnightPathFinder

  DISPLACEMENTS = [[2,1], [1,2], [-2,-1], [-1,-2],
                  [2,-1], [-1,2], [-2,1], [1,-2]]

  attr_reader :root, :visited_positions, :root_node

  def initialize(root)
    @visited_positions = [root]
    @root = root
    @root_node = PolyTreeNode.new(root)
  end

  def find_path(target_pos)
    build_move_tree(@root_node)
    if @visited_positions.include?(target_pos)
      @root_node.dfs(target_pos)
    else
      false
    end
  end

  def build_move_tree(root_node)
    possible_positions = DISPLACEMENTS.map do |x, y|
      [x + root_node.value[0], y + root_node.value[1]]
    end

    possible_positions = possible_positions.select do |move|
      valid_move?(move)
    end

    possible_positions.each do |move|
      @visited_positions << move
      child = PolyTreeNode.new(move)
      child.parent = root_node
      build_move_tree(child)
    end

  end

  def valid_move?(pos)
    pos.all? {|x| 0 <= x && x <= 7 } && !@visited_positions.include?(pos)
  end

  # Aaron's way

  def find_path_aaron(target_pos)
    found_node = search_for_target(@root_node, target_pos)
    traverse_path(found_node)
  end

  def traverse_path(node)
    path_positions = [node.value]
    current_node = node
    while current_node.parent != nil
      path_positions.unshift(current_node.parent.value)
      current_node = current_node.parent
    end
    path_positions
  end

  def search_for_target(start_node, target_pos)
    queue = [start_node]
    while !queue.empty?
      current_node = queue.shift
      possible_positions = []
      DISPLACEMENTS.each do |x, y|
        move = [x + current_node.value[0], y + current_node.value[1]]
        possible_positions << move if valid_move?(move)
      end
      possible_positions.each do |position|
        child = PolyTreeNode.new(position)
        child.parent = current_node
        if target_pos == position
          return child
        end
        @visited_positions << position
        queue << child
      end
    end
  end
end

test_case = KnightPathFinder.new([0,0])
puts test_case.find_path_aaron([7,2]).to_s
test_case.visited_positions.each { |pos| print "#{pos}\n" }

# test_case = KnightPathFinder.new([0,0])
# test_case.build_move_tree(test_case.root_node)
# test_case.visited_positions.each { |pos| print "#{pos}\n" }
# puts test_case.find_path([6,3])
