PROJECT 2 README
Track Generation, Kinematic Simulation, and Animation

Description
This script creates a closed racetrack, runs a kinematic vehicle simulation in Simulink, and animates the car driving around the track. The track is made of two straight sections and two semicircular turns. After the animation, race statistics are calculated using the simulated vehicle trajectory.

Vehicle Setup
The script begins by defining vehicle properties in a structure called carData. This includes mass, inertia, tire cornering stiffness values, axle distances, and initial conditions like position, velocity, and heading. The understeer coefficient is also calculated using these parameters.

Track Generation
A structure called path is used to store the track geometry. The track is generated point by point using a loop. Straight sections are created by stepping forward in the x direction, and curved sections are created by rotating vectors using a rotation function. The script stores:

centerline coordinates

inside track boundary

outside track boundary

heading along the path

Simulation
The script runs the Simulink model:

sim("Project_2_Kinematic_Model.slx")

The model outputs vehicle position and heading over time, which are stored in:

car_X

car_Y

car_psi

car_time

Animation
The track is plotted first, and then the car is animated as a rectangle that rotates based on the heading angle from the simulation. The animation updates the car’s position at each time step.

Race Statistics
After the animation, the script calls the raceStat function to compute statistics about the vehicle’s motion along the track.

Required Files
Make sure these files are in the same folder:

Project_2_Kinematic_Model.slx

raceStat.m

this script

How to Run
Open MATLAB, navigate to the project folder, and run the script. A figure window will open showing the track and the animated vehicle.

Outputs
Running the script produces:

a generated track stored in path

vehicle trajectory data from Simulink

an animation of the vehicle

race statistics stored in race
