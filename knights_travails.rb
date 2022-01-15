class Knight
    def initialize(coordinates)
        @x = coordinates[0]
        @y = coordinates[1]
    end

    def go_to(destination)
        board = Board.new()
        now_at = board.squares.find { |square| [square.x, square.y] == [@x, @y] } 
        board.shortest_path([[[],now_at]], destination)
    end

end

class Square

    attr_reader :x, :y
    attr_accessor :children, :array, :visited

    def initialize(x, y)
        @x = x
        @y = y
        @array = [x, y]
        @children = []
        @visited = false
    end

end

class Board

    attr_reader :squares

    def initialize()
        @squares = make_new_board()
    end

    def make_new_board()
        squares = []
        (0..7).inject(1) do |sum, a|
            (0..7).inject(1) { |sum, b| squares.push(Square.new(a, b)) }
        end
        squares.each do |square|
            x = square.x
            y = square.y
            square.children = squares.select do |s|
                case s.array
                    when [x+1, y+2], [x-1, y-2], [x+1, y-2], [x-1, y+2], [x+2, y+1], [x-2, y-1], [x+2, y-1], [x-2, y+1] then true
                end
            end
        end
        squares
    end

    def shortest_path(queue, going_to)
        new_queue = []
        queue.each do |path_and_square|
            path = path_and_square[0]
            square = path_and_square[1]
            return path.push(square.array) if square.array == going_to
            square.visited = true
            unvisited_children = square.children.select { |child| !child.visited } 
            unvisited_children.each do |unvisited_child|
                unvisited_child.visited = true
                new_queue.push([Array.new(path).push(square.array), unvisited_child])
            end
        end
        new_queue.empty? ? [] : shortest_path(new_queue, going_to)
    end

end

def knight_moves(start_point, end_point)
    knight = Knight.new(start_point)
    steps = knight.go_to(end_point)
    puts "You reached the end point in #{steps.length-1} steps! Here's the path:"
    p steps
end

knight_moves([0,0], [7,7])
knight_moves([0,0],[1,2])
knight_moves([0,0],[3,3])
knight_moves([3,3],[0,0])
knight_moves([3,3],[4,3])