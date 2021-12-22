class Knight
    def initialize(coordinates)
        @x = coordinates[0]
        @y = coordinates[1]
    end

    def go_to(destination)
        board = Board.new()
        now_at = board.squares.find { |square| [square.x, square.y] == [@x, @y] } 
        board.shortest_path(now_at, destination)
    end

end

class Square

    attr_reader :x, :y
    attr_accessor :children, :array

    def initialize(x, y)
        @x = x
        @y = y
        @array = [x, y]
        @children = []
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

    def shortest_path(now_at, going_to, parent = now_at, shortest_path = [], path = [])
        p square = now_at.array
        if (square == going_to) && (shortest_path.empty? || path.length < shortest_path.length)
            return path
        elsif (square != going_to) && (!path[0..-2].include?(square))
            path = path.push(square)
            child = now_at.children[0]
            shortest_path = shortest_path(child, going_to, now_at, shortest_path, path)
        elsif (square != going_to) && (path[0..-2].include?(square))
            index = parent.children.find_index(now_at) + 1
            if parent.children[index].nil?
                return shortest_path
            else
                shortest_path = shortest_path(parent, going_to, parent, shortest_path, path)
            end
        end
        shortest_path
    end
end

def knight_moves(start_point, end_point)
    knight = Knight.new(start_point)
    steps = knight.go_to(end_point)
    puts "You reached the end point in #{steps.length} steps! Here's the path:"
    p steps
end

knight_moves([0,0], [7,7])