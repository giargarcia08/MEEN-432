%clear
%clc
%A=10;
%w0=10;
%J=0.1;
%b=1;


%% 
clear
clc
j = 10;        % kg*m^2 (rotational inertia)
b = 0.1;         % N*m*s/rad (damping)
w0 = 10;        % rad/s (starting angular speed)
w=10;
A= 100;           % N-m (applied constant torque)
k=10;

%% We need to create a table T
%from the simulink export the data into the workspace and create the table
%using logging 
%T=extractTimetable(out.simout);
% Extract time and data from the Simulink output

time = out.simout1.time; % Time data
data = out.simout1.data; % Signal values

% Create a figure for the plot
figure;

% Plot the data
plot(time, data);
grid on;
xlabel('Time (s)');
ylabel('Signal Values');
title('Simulink Output Data');
legend('Signal 1', 'Location', 'best'); % Adjust legend as necessary based on the number of signals

%% # Ideally parameters put in table T
%T = cell2table(out, "VariableNames", ...
  %["inputType","w0","J","b","A","freq","solver","dt","cpuTime","maxErr"]);
T=table(time,data);
disp(T);

%{
save("P1S1.mat","T");

Load or recall this table
load("P1S1.mat","T");
part1_plots_student
%}






%% part1_plots_student.m
% Plots for Part 1
% Assumes you already have a table called T in the workspace.
% Example:
%   load('part1_results.mat','T')

clc;

% --- quick check that the important columns exist ---
vars = string(T.Properties.VariableNames);

if ~any(vars=="solver");  error("T needs a column named solver");  end
if ~any(vars=="dt");      error("T needs a column named dt");      end
if ~any(vars=="cpuTime"); error("T needs a column named cpuTime"); end
if ~any(vars=="maxErr");  error("T needs a column named maxErr");  end

% make sure solver is a string so comparing is easier
if ~isstring(T.solver)
    T.solver = string(T.solver);
end

% if solverType isn't there, just make one (fixed vs variable)
if ~any(vars=="solverType")
    T.solverType = repmat("variable", height(T), 1);

    % fixed-step solvers we used in class
    for i = 1:height(T)
        if T.solver(i) == "ode1" || T.solver(i) == "ode4"
            T.solverType(i) = "fixed";
        end
    end
end

% if freq isn't there, set it to 0 (so the contour plot still works)
if ~any(vars=="freq")
    T.freq = zeros(height(T),1);
end

% if eigenvalue isn't there but J and b exist, compute it
vars = string(T.Properties.VariableNames); % refresh since we maybe added columns
if ~any(vars=="eig")
    if any(vars=="J") && any(vars=="b")
        T.eig = -T.b ./ T.J;
    else
        T.eig = NaN(height(T),1);
    end
end

%% =========================
%  Plot 1: Max error vs dt
%  (fixed-step only)
%% =========================
fixedOnly = T(T.solverType=="fixed", :);
fixedOnly = fixedOnly(~isnan(fixedOnly.dt), :);

solvers = unique(fixedOnly.solver);

figure;
hold on;

for s = 1:length(solvers)
    solverName = solvers(s);

    % pick rows for this solver
    useRows = fixedOnly(fixedOnly.solver == solverName, :);

    % all dt values that show up for this solver
    dtVals = unique(useRows.dt);
    dtVals = sort(dtVals);

    errAvg = zeros(size(dtVals));

    % average error across all cases (keeps plot readable)
    for k = 1:length(dtVals)
        errAvg(k) = mean(useRows.maxErr(useRows.dt == dtVals(k)), "omitnan");
    end

    plot(dtVals, errAvg, "-o", "DisplayName", solverName);
end

grid on;
xlabel("dt (s)");
ylabel("Average max error");
title("Max error vs dt (fixed-step)");
legend("Location","best");


%% =========================
%  Plot 2: CPU time vs dt
%  (fixed-step only)
%% =========================
figure;
hold on;

for s = 1:length(solvers)
    solverName = solvers(s);

    useRows = fixedOnly(fixedOnly.solver == solverName, :);

    dtVals = unique(useRows.dt);
    dtVals = sort(dtVals);

    cpuAvg = zeros(size(dtVals));

    for k = 1:length(dtVals)
        cpuAvg(k) = mean(useRows.cpuTime(useRows.dt == dtVals(k)), "omitnan");
    end

    plot(dtVals, cpuAvg, "-o", "DisplayName", solverName);
end

grid on;
xlabel("dt (s)");
ylabel("Average CPU time (s)");
title("CPU time vs dt (fixed-step)");
legend("Location","best");


%% =========================
%  Plot 3: Max error vs CPU time (all solvers)
%% =========================
figure;
gscatter(T.cpuTime, T.maxErr, T.solver);
grid on;
xlabel("CPU time (s)");
ylabel("Max error");
title("Max error vs CPU time");


%% =========================
%  Plot 4: Contours of constant eigenvalue on CPU vs Error
%  (only if eig exists / isn't all NaN)
%% =========================
if any(~isnan(T.eig))
    figure;

    x = T.cpuTime;
    y = T.maxErr;
    z = T.eig;

    % build grid automatically from the data range
    xg = linspace(min(x), max(x), 40);
    yg = linspace(min(y), max(y), 40);
    [Xg, Yg] = meshgrid(xg, yg);

    Zg = griddata(x, y, z, Xg, Yg, "natural");

    contour(Xg, Yg, Zg, 10);
    grid on;
    xlabel("CPU time (s)");
    ylabel("Max error");
    title("Eigenvalue contours (approx)");
else
    warning("No eigenvalue data available (eig missing or all NaN), skipping Plot 4.");
end


%% =========================
%  Plot 5: Contours of constant input frequency on CPU vs Error
%% =========================
figure;

x = T.cpuTime;
y = T.maxErr;
z = T.freq;

xg = linspace(min(x), max(x), 40);
yg = linspace(min(y), max(y), 40);
[Xg, Yg] = meshgrid(xg, yg);

Zg = griddata(x, y, z, Xg, Yg, "natural");

contour(Xg, Yg, Zg, 10);
grid on;
xlabel("CPU time (s)");
ylabel("Max error");
title("Input frequency contours (approx)");
