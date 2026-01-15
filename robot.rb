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

  def place(x, y, direction)
    return if ignore?(x, y)

    @x_position = x
    @y_position = y
    @direction = direction
    puts "Placing robot at #{@x_position},#{@y_position},#{@direction}"
  end

  def move
    return if ignore?

    tmp_x, tmp_y = MOVEMENTS[@direction]

    return if ignore?(@x_position + tmp_x, @y_position + tmp_y)

    @x_position += tmp_x
    @y_position += tmp_y

    puts "Moved to #{@x_position},#{@y_position}"
  end

  def change_direction(new_index)
    return if ignore?

    current_facing_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_facing_index + new_index) % DIRECTIONS.length]
    puts "Changed direction to #{@direction}"
  end

  def report
    return if ignore?

    puts '*' * 30
    puts "OUTPUT: #{@x_position},#{@y_position},#{@direction}\n"
    puts '*' * 30
  end

  private

  # Ignore if the position is out of bounds
  def ignore?(x = @x_position, y = @y_position)
    return true if x.nil? || y.nil?

    (x.negative? || x >= TABLE_SIZE) || (y.negative? || y >= TABLE_SIZE)
  end

  def normalize(command)
    command
      .strip
      .gsub(/\s+/, ' ')      # collapse multiple spaces
      .gsub(/\s*,\s*/, ',')  # remove spaces around commas
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
