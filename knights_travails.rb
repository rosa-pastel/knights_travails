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
            square.children = squares.select do |sq|
                case sq.array
                    when [x+1, y+2], [x-1, y-2], [x+1, y-2], [x-1, y+2], [x+2, y+1], [x-2, y-1], [x+2, y-1], [x-2, y+1] then true
                end
            end
        end
        squares
    end

    def shortest_path(queue, going_to, new_queue = [])
        queue.each do |now_at|
            return now_at[:path].push(now_at[:square].array) if now_at[:square].array == going_to
            unvisited = now_at[:square].children.select { |child| !child.visited }
            now_at[:square].visited = true
            unvisited.each do |unvisited_child|
                unvisited_child.visited = true
                new_queue.push({path: Array.new(now_at[:path]).push(now_at[:square].array), square: unvisited_child})
            end
        end
        new_queue.empty? ? [] : shortest_path(new_queue, going_to)
    end

end

def knight_moves(start_point, end_point)
    board = Board.new()
    start = board.squares.find { |square| [square.x, square.y] == [start_point[0], start_point[1]] } 
    steps = board.shortest_path([{path:[],square:start}], end_point)
    puts "You reached the end point in #{steps.length-1} steps! Here's the path:\n" + steps.to_s
end

knight_moves([0,0], [7,7])
knight_moves([0,0],[1,2])
knight_moves([0,0],[3,3])
knight_moves([3,3],[0,0])
knight_moves([3,3],[4,3])