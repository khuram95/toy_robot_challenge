# frozen_string_literal: true

require 'minitest/autorun'
require './robot'

# Test suite for Robot class
class RobotTest < Minitest::Test
  def setup
    @robot = Robot.new
  end

  # Ignore all commands before place
  def ignore_move_command_before_place
    @robot.execute('MOVE')
    assert_nil @robot.x_position, 'X position should be nil before place'
    assert_nil @robot.y_position, 'Y position should be nil before place'
  end

  def ignore_left_right_command_before_place
    @robot.execute('LEFT')
    @robot.execute('RIGHT')
    assert_nil @robot.direction, 'Direction should be nil before place'
  end

  # Place the robot
  def test_place
    @robot.execute('PLACE 0,0,EAST')
    assert_equal 'EAST', @robot.direction, 'Direction should be EAST after place'
  end

  # should not place the robot out of bounds
  def test_place_out_of_bounds
    @robot.execute('PLACE 5,5,EAST')
    assert_nil @robot.x_position, 'X position should be nil after place out of bounds'
    assert_nil @robot.y_position, 'Y position should be nil after place out of bounds'
  end

  # Move the robot
  def test_move
    @robot.execute('PLACE 0,0,EAST')
    @robot.execute('MOVE')
    assert_equal 1, @robot.x_position, 'X position should be 1 after move'
    assert_equal 0, @robot.y_position, 'Y position should be 0 after move'
  end

  # should not move the robot out of bounds
  def test_move_out_of_bounds
    @robot.execute('PLACE 4,0,EAST')
    @robot.execute('MOVE')
    assert_equal 4, @robot.x_position, 'X position should be 4 after move out of bounds'
    assert_equal 0, @robot.y_position, 'Y position should be 0 after move out of bounds'
  end

  # Change direction
  def test_left_direction
    @robot.execute('PLACE 0,0,EAST')
    @robot.execute('LEFT')
    assert_equal 'NORTH', @robot.direction, 'Direction should be NORTH after left'
  end

  def test_right_direction
    @robot.execute('PLACE 0,0,EAST')
    @robot.execute('RIGHT')
    assert_equal 'SOUTH', @robot.direction, 'Direction should be SOUTH after right'
  end

  # Report the robot's position and direction
  def test_report
    @robot.execute('PLACE 0,0,EAST')
    assert_output("#{'*' * 30}\nOUTPUT: 0,0,EAST\n#{'*' * 30}\n") do
      @robot.execute('REPORT')
    end
  end

  # Test 12: Commands with extra whitespace
  def test_command_with_extra_whitespace
    @robot.execute('  PLACE  2  ,  3  ,  NORTH  ')
    assert_equal 2, @robot.x_position, 'X position should be 2 after command with extra whitespace'
    assert_equal 3, @robot.y_position, 'Y position should be 3 after command with extra whitespace'
    assert_equal 'NORTH', @robot.direction, 'Direction should be NORTH after command with extra whitespace'
  end

  # Edge cases: Negative coordinates
  def test_place_with_negative_x
    @robot.execute('PLACE -1,2,NORTH')
    assert_nil @robot.x_position, 'Negative X should be rejected'
    assert_nil @robot.y_position
  end

  def test_place_with_negative_y
    @robot.execute('PLACE 2,-1,NORTH')
    assert_nil @robot.x_position, 'Negative Y should be rejected'
    assert_nil @robot.y_position
  end

  # Edge cases: Boundary values
  def test_place_at_boundary_x5
    @robot.execute('PLACE 5,2,NORTH')
    assert_nil @robot.x_position, 'X position 5 should be rejected (table is 0-4)'
    assert_nil @robot.y_position
  end

  def test_place_at_boundary_y5
    @robot.execute('PLACE 2,5,NORTH')
    assert_nil @robot.x_position, 'Y position 5 should be rejected (table is 0-4)'
    assert_nil @robot.y_position
  end

  # Edge cases: All corners
  def test_move_from_top_right_corner_north
    @robot.execute('PLACE 4,4,NORTH')
    @robot.execute('MOVE')
    assert_equal 4, @robot.x_position
    assert_equal 4, @robot.y_position, 'Robot should not move off the table'
  end

  def test_move_from_bottom_left_corner_west
    @robot.execute('PLACE 0,0,WEST')
    @robot.execute('MOVE')
    assert_equal 0, @robot.x_position, 'Robot should not move off the table'
    assert_equal 0, @robot.y_position
  end

  # Edge cases: Invalid PLACE command formats
  def test_invalid_place_format_missing_comma
    @robot.execute('PLACE 2 3 NORTH')
    assert_nil @robot.x_position, 'Invalid PLACE format should be ignored'
  end

  def test_invalid_place_format_wrong_direction
    @robot.execute('PLACE 2,3,NORTHEAST')
    assert_nil @robot.x_position, 'Invalid direction should be ignored'
  end

  def test_invalid_place_with_non_numeric_coordinates
    @robot.execute('PLACE a,b,NORTH')
    assert_nil @robot.x_position, 'Non-numeric coordinates should be ignored'
  end

  def test_invalid_place_with_too_many_arguments
    @robot.execute('PLACE 1,2,3,NORTH')
    assert_nil @robot.x_position, 'Too many arguments should be ignored'
  end

  def test_invalid_place_with_too_few_arguments
    @robot.execute('PLACE 1,2')
    assert_nil @robot.x_position, 'Too few arguments should be ignored'
  end

  # Edge cases: Commands before valid PLACE
  def test_commands_before_valid_place
    @robot.execute('MOVE')
    @robot.execute('LEFT')
    @robot.execute('RIGHT')
    @robot.execute('REPORT')
    @robot.execute('PLACE 5,5,NORTH') # Invalid place
    @robot.execute('MOVE')
    @robot.execute('PLACE 2,2,EAST') # Valid place
    assert_equal 2, @robot.x_position
    assert_equal 2, @robot.y_position
    assert_equal 'EAST', @robot.direction
  end

  # Edge cases: REPORT before PLACE
  def test_report_before_place
    assert_output('') do
      @robot.execute('REPORT')
    end
  end

  # Edge cases: Multiple PLACE commands
  def test_multiple_place_commands
    @robot.execute('PLACE 0,0,NORTH')
    @robot.execute('PLACE 3,3,SOUTH')
    assert_equal 3, @robot.x_position
    assert_equal 3, @robot.y_position
    assert_equal 'SOUTH', @robot.direction
  end

  # Edge cases: Empty and whitespace-only commands
  def test_empty_command
    @robot.execute('PLACE 2,2,NORTH')
    @robot.execute('')
    assert_equal 2, @robot.x_position, 'Empty command should not affect position'
    assert_equal 2, @robot.y_position
  end

  def test_whitespace_only_command
    @robot.execute('PLACE 2,2,NORTH')
    @robot.execute('   ')
    assert_equal 2, @robot.x_position, 'Whitespace-only command should not affect position'
  end

  # Edge cases: Moving from edges
  def test_move_from_top_edge
    @robot.execute('PLACE 2,4,NORTH')
    @robot.execute('MOVE')
    assert_equal 4, @robot.y_position, 'Should not move north from top edge'
  end

  def test_move_from_bottom_edge
    @robot.execute('PLACE 2,0,SOUTH')
    @robot.execute('MOVE')
    assert_equal 0, @robot.y_position, 'Should not move south from bottom edge'
  end

  def test_move_from_right_edge
    @robot.execute('PLACE 4,2,EAST')
    @robot.execute('MOVE')
    assert_equal 4, @robot.x_position, 'Should not move east from right edge'
  end

  def test_move_from_left_edge
    @robot.execute('PLACE 0,2,WEST')
    @robot.execute('MOVE')
    assert_equal 0, @robot.x_position, 'Should not move west from left edge'
  end

  # Edge cases: Multiple rotations
  def test_four_left_rotations
    @robot.execute('PLACE 2,2,NORTH')
    4.times { @robot.execute('LEFT') }
    assert_equal 'NORTH', @robot.direction, 'Four LEFT rotations should return to original direction'
  end

  def test_four_right_rotations
    @robot.execute('PLACE 2,2,EAST')
    4.times { @robot.execute('RIGHT') }
    assert_equal 'EAST', @robot.direction, 'Four RIGHT rotations should return to original direction'
  end

  # Edge cases: Complex sequence
  def test_complex_sequence
    @robot.execute('PLACE 1,2,EAST')
    @robot.execute('MOVE')
    @robot.execute('MOVE')
    @robot.execute('LEFT')
    @robot.execute('MOVE')
    assert_equal 3, @robot.x_position
    assert_equal 3, @robot.y_position
    assert_equal 'NORTH', @robot.direction
  end
end
