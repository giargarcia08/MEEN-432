# Part 2 – README (Options 1, 2, 3)

This is the script for Part 2 where all three coupling options are run and compared.

It runs the Simulink models a bunch of times with different:
- torques
- stiffness values (for option 1)
- solvers
- time steps

Then it stores everything in a table and makes the comparison plots the project asks for.

---

## Stuff that needs to be in the folder

You need these models:

- P1S2_opt1_flexibleShaft.slx
- P1S2_opt2_combined.slx
- P1S2_opt3_S2integrates.slx

Also the build functions:
- build_opt1
- build_opt2
- build_opt3

And this script.

If the models are not there yet, the script tries to build them.

---

## Parameters it uses

From the project instructions:

J1 = 100, b1 = 1  
J2 = 1, b2 = 1  

Step torques:
A = 1 and 100

Stiffness for option 1:
k = 10, 100, 1000

Solvers:
ode1, ode4 with dt = 0.1 and 1  
ode45

Simulation time is 25 seconds.

All of this gets pushed into the base workspace so Simulink can see it.

---

## What this script actually does

For every combo of A, k, solver, dt:

- runs Option 1
- runs Option 2
- runs Option 3
- records CPU time for each one
- saves shaft speed data into a table called T

Later the script pulls from that table to make plots.

---

## The plots it makes

It only plots the cases we care about for the report:

- ode4 with dt = 0.1
- ode45

For each A and k it makes a figure that shows:

- Option 1 speeds at both ends of the shaft
- Option 2 combined shaft speed
- Option 3 speeds

So you can see how the three approaches behave on the same graph.

---

## VERY IMPORTANT (signal names)

Your Simulink models have to be logging these with To Workspace blocks:

Option 1:
- w1
- w2

Option 2:
- w

Option 3:
- w1
- w2

If not, the plots will be blank.

---

## How to run it

Open MATLAB, go to the folder, run the script.

It will spit out a lot of figures.

---

## If something is wrong

Empty plots → signal names don’t match  
Models not found → .slx files or build functions missing  
Solver not changing → check solver settings in the model

---

## Notes

CPU time is measured with tic/toc.

The table T is basically the master data for all runs.

This is the script that actually creates the comparison plots you need for Part 2.


