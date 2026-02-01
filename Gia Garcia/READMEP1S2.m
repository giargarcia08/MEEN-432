# Project 1 – Part 2 README (Option 3 Script)

## What this is
This script runs the Part 2 simulations for the coupled two-shaft system using the **Option 3 approach** (where S2 handles the integration). It automatically runs a bunch of cases with different torques, stiffness values, solvers, and time steps.

While it runs, it:
- simulates the Simulink models
- plots shaft speeds vs time
- saves all time histories into a table called `T2`
- pulls out CPU times into a smaller table
- saves the results to a `.mat` file and a `.csv`

---

## What needs to be in the folder
You need these three Simulink models in the same folder as the script (or at least on the MATLAB path):

- `P1Opt3.slx`
- `P1S2sim2.slx`
- `P1S2sim_2_.slx`

And this MATLAB script (whatever you named it).

---

## Very important: signal logging in Simulink
The script assumes certain signals are being logged to the workspace. If the names don't match, the script will crash.

Make sure these exist:

### From `P1Opt3`
- `out.w3.time`
- `out.w3.data`

### From `P1S2sim2`
- `out.w2.time`
- `out.w2.data`

### From `P1S2sim_2_`
- `out.w1a.time`
- `out.w1a.data`

If your signals have different names, either rename them in Simulink or change the script.

---

## Parameters used in the script

These are pushed into the base workspace so the models can read them.

### System values
- `J1 = 100`, `b1 = 1`
- `J2 = 1`, `b2 = 1`

### Inputs tested
- Step torque: `A = 1` and `A = 100` Nm
- Stiffness: `k = 10, 100, 1000`

### Initial conditions
- All speeds and angles start at 0

### Solvers tested
Fixed step:
- `ode1`, `ode4`
- `dt = 0.1` and `1`

Variable step:
- `ode45`

Simulation time:
- 25 seconds

---

## What the script makes

### Plots
For every combination of torque and stiffness, the script makes:
- One figure for ode1/ode4 runs
- One figure for ode45

Each plot compares:
- `w3` from `P1Opt3`
- `w2` from `P1S2sim2`
- `w1a` from `P1S2sim_2_`

---

## Output files created

When it finishes, you will have:

### `P2_option3_results.mat`
Contains:
- `T2` (full results, including time histories)
- `CPU_Table` (just the CPU times for successful runs)

### `P2_option3_CPUtimes.csv`
A spreadsheet version of the CPU times.

---

## What is inside the table `T2`

Each row is one simulation case.

It stores:
- solver used
- time step
- torque value
- stiffness value
- CPU time
- whether it ran successfully
- error message if it failed
- the full time and speed data from all three models

`CPU_Table` is just a filtered version showing only the CPU times.

---

## How to run this

1. Open MATLAB.
2. Make sure the script and the `.slx` files are in the same folder.
3. Change MATLAB's current folder to that location.
4. Run the script.

That's it. It will take a few minutes and generate a lot of plots.

---

## Common problems

### Model names don't match
If your Simulink files have different names, change these at the top of the script:
- `model_3`
- `model_2`
- `model`

### Signals not logging
If you get errors about `out.w3` or `out.w1a`, your signals are not being logged correctly.

### Solver settings not changing
Make sure the solver in each model is allowed to be changed by the script (check Model Settings → Solver).

---

## Notes
- CPU time is measured using `tic` and `toc`.
- The script uses `try/catch` so even failed runs still get recorded in the table.
- Expect a lot of figures to pop up while it runs.
