require 'minitest/autorun'
require './robot'

class RobotTest < Minitest::Test
  def setup
    @robot = Robot.new
  end

  # Ignore all commands before place
  def ignore_move_command_before_place
    @robot.execute('MOVE')
    assert_nil @robot.x_position , "X position should be nil before place"
    assert_nil @robot.y_position, "Y position should be nil before place"
  end

  def ignore_left_right_command_before_place
    @robot.execute('LEFT')
    @robot.execute('RIGHT')
    assert_nil @robot.direction, "Direction should be nil before place"
  end

  # Place the robot
  def test_place
    @robot.place(0, 0, 'EAST')
    assert_equal 'EAST', @robot.direction, "Direction should be EAST after place"
  end

  # should not place the robot out of bounds
  def test_place_out_of_bounds
    @robot.place(5, 5, 'EAST')
    assert_nil @robot.x_position, "X position should be nil after place out of bounds"
    assert_nil @robot.y_position, "Y position should be nil after place out of bounds"
  end

  # Move the robot
  def test_move
    @robot.place(0, 0, 'EAST')
    @robot.move
    assert_equal 1, @robot.x_position, "X position should be 1 after move"
    assert_equal 0, @robot.y_position, "Y position should be 0 after move"
  end

  # should not move the robot out of bounds
  def test_move_out_of_bounds
    @robot.place(4, 0, 'EAST')
    @robot.move
    assert_equal 4, @robot.x_position, "X position should be 4 after move out of bounds"
    assert_equal 0, @robot.y_position, "Y position should be 0 after move out of bounds"
  end

  # Change direction
  def test_left_direction
    @robot.place(0, 0, 'EAST')
    @robot.change_direction(-1)
    assert_equal 'NORTH', @robot.direction, "Direction should be NORTH after left"
  end

  def test_right_direction
    @robot.place(0, 0, 'EAST')
    @robot.change_direction(1)
    assert_equal 'SOUTH', @robot.direction, "Direction should be SOUTH after right"
  end

  # Report the robot's position and direction
  def test_report
    @robot.place(0, 0, 'EAST')
    @robot.report
    assert_output("*"*30 + "\nOUTPUT: 0,0,EAST\n" + "*"*30 + "\n") do
      @robot.report
    end #"Report should output 0,0,EAST after report"
  end

   # Test 12: Commands with extra whitespace
   def test_command_with_extra_whitespace
    @robot.execute('  PLACE  2  ,  3  ,  NORTH  ')
    assert_equal 2, @robot.x_position, "X position should be 2 after command with extra whitespace"
    assert_equal 3, @robot.y_position, "Y position should be 3 after command with extra whitespace"
    assert_equal 'NORTH', @robot.direction, "Direction should be NORTH after command with extra whitespace"
  end
end
