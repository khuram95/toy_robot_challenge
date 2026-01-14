# Toy Robot Simulator

## Description

The task is to create a simulation of a toy robot moving on a square tabletop of dimensions 5 units x 5 units.

• There are no obstructions on the table surface.

• The robot is free to move around the surface, but must not fall off the table.

• Any movement that would cause the robot to fall must be ignored, while valid commands should still be accepted and executed.

## Application Requirements

Your application must be able to read and process the following commands:

• PLACE X,Y,F

• MOVE

• LEFT

• RIGHT

• REPORT

## Command Details

### PLACE X,Y,F

o Places the robot on the table at coordinates (X, Y), facing direction F (NORTH, SOUTH, EAST, or WEST).

o The origin (0,0) represents the south-west corner of the table.

o The first valid command must be a PLACE command.

o Any commands before a valid PLACE should be ignored.

o Additional PLACE commands can be used to reposition the robot.

### MOVE

o Moves the robot one unit forward in the direction it is currently facing.

### LEFT / RIGHT

o Rotates the robot 90° in the specified direction without changing its position.

### REPORT

o Outputs the current X, Y, and F (facing direction) of the robot.

o Output format is flexible, but standard console output is sufficient.

## Constraints

• The robot must not fall off the table.

• Any move that would result in the robot falling should be ignored.

• A robot not yet placed on the table should ignore all commands except PLACE.

• Input may be provided via file or standard input, at your discretion.

• Please include test data to demonstrate your solution.

## Example Input and Output

### Example A

• PLACE 0,0,NORTH

• MOVE

• REPORT

• Output: 0,1,NORTH

### Example B

• PLACE 0,0,NORTH

• LEFT

• REPORT

• Output: 0,0,WEST

### Example C

• PLACE 1,2,EAST

• MOVE

• MOVE

• LEFT

• MOVE

• REPORT

• Output: 3,3,NORTH
