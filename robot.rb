# frozen_string_literal: true

require 'English'

# Simulates a toy robot moving on a 5x5 tabletop
class Robot
  DIRECTIONS = %w[EAST SOUTH WEST NORTH].freeze
  TABLE_SIZE = 5
  MOVEMENTS = DIRECTIONS.zip([
                               [1, 0], # EAST
                               [0, -1],  # SOUTH
                               [-1, 0],  # WEST
                               [0, 1]    # NORTH
                             ]).to_h.freeze
  PLACE_PATTERN = /^PLACE\s+(?<x>\d+),(?<y>\d+),(?<direction>#{DIRECTIONS.join('|')})$/
  private_constant :DIRECTIONS, :TABLE_SIZE, :MOVEMENTS, :PLACE_PATTERN

  attr_reader :x_position, :y_position, :direction

  def execute(command)
    command = normalize(command)
    case command.upcase
    when PLACE_PATTERN
      place($LAST_MATCH_INFO[:x].to_i, $LAST_MATCH_INFO[:y].to_i, $LAST_MATCH_INFO[:direction])
    when 'MOVE'
      move
    when 'LEFT'
      change_direction(-1)
    when 'RIGHT'
      change_direction(1)
    when 'REPORT'
      report
    else
      puts "Invalid command: #{command}"
    end
  end

  private

  def place(x, y, direction)
    return if out_of_bounds?(x, y)

    @x_position = x
    @y_position = y
    @direction = direction
    puts "Placing robot at #{@x_position},#{@y_position},#{@direction}"
  end

  def move
    return unless placed?

    tmp_x, tmp_y = MOVEMENTS[@direction]

    return if out_of_bounds?(@x_position + tmp_x, @y_position + tmp_y)

    @x_position += tmp_x
    @y_position += tmp_y

    puts "Moved to #{@x_position},#{@y_position}"
  end

  def change_direction(new_index)
    return unless placed?

    current_facing_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_facing_index + new_index) % DIRECTIONS.length]
    puts "Changed direction to #{@direction}"
  end

  def report
    return unless placed?

    puts '*' * 30
    puts "OUTPUT: #{@x_position},#{@y_position},#{@direction}\n"
    puts '*' * 30
  end

  # Check if the robot is placed on the table (not nil)
  def placed?
    !@x_position.nil? && !@y_position.nil? && !@direction.nil?
  end

  # Check if the position is out of bounds
  def out_of_bounds?(x, y)
    x.negative? || x >= TABLE_SIZE || y.negative? || y >= TABLE_SIZE
  end

  def normalize(command)
    command.strip.gsub(/(\s*,\s*)|(\s+)/) { |match| match.include?(',') ? ',' : ' ' }
  end
end

if __FILE__ == $PROGRAM_NAME
  puts 'Enter commands:'
  robot = Robot.new

  if ARGV[0]
    File.readlines(ARGV[0]).each do |line|
      robot.execute(line.strip)
    end
  else
    while (line = $stdin.gets)
      robot.execute(line.strip)
    end
  end
end
