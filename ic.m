function ic(imp0)
  % Initialization 
  close all;
  clc;
  clear;
  s = 200;
  maxtime = 50;
  imp0 = 377.0;

  % Initialize the arrays
  ez = zeros(1, s);
  hy = zeros(1, s);
  ez_51_vs_time = zeros(1, maxtime); % Array to store ez(51) values

  % Create a figure for the animation
  figure;
  h1 = plot(ez, '-b', 'LineWidth', 2);
  xlabel('Position');
  ylabel('Field Amplitude');
  title('Electric and Magnetic Fields');
  legend('Electric Field (ez)');
  grid on;
  ylim([0, 1]); % Adjust the y-axis limits as needed

  % Time stepping loop
  for qtime = 0:maxtime-1
    % Update the magnetic field 
    for mm = 1:s-1
      hy(mm) = hy(mm) + (ez(mm+1) - ez(mm)) / imp0;
    end
    % Update electric field
    for mm = 2:s
      ez(mm) = ez(mm) + (hy(mm) - hy(mm-1)) * imp0;
    end
    % Hardwire a source node
    ez(1) = exp(-((qtime - 30)^2) / 100);

    % Store the value of ez(51)
    ez_51_vs_time(qtime + 1) = ez(51);

    % Update the plot data
    set(h1, 'YData', ez);
    drawnow; % Update the figure window

    % Display the value at node 51
    fprintf('%g\n', ez(51));
  end

  % Plot ez(51) vs. qtime
  figure;
  plot(0:maxtime-1, ez_51_vs_time, '-r', 'LineWidth', 2);
  xlabel('Time Step');
  ylabel('ez(51)');
  title('ez(51) vs. Time Step');
  grid on;
end
