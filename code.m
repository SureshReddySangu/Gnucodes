function code(imp0)
    close all;
    clc;
    clear;

    % Define parameters
    s = 200;          % Size of the array
    imp0= 377.0;      % Magnetic constant
    maxtime = 1000;     % Maximum time or simulation duration
    % Initialize arrays
    ez = zeros(1, s+1); % ez array of size (s+1) for 1-based indexing
    hy = zeros(1, s);   % hy array of size s for 1-based indexing
    ez_51 = zeros(1, maxtime); % ez array of size (s+1) for 1-based indexing
    % Define initial condition for ez
    

    % Create figures and axes for real-time plotting
    figure;
    subplot(3,1,1);
    hyPlot = plot(1:s, hy, 'b');
    title('Real-time hy');
    xlabel('Index');
    ylabel('hy');
    ylim([0 0.02]); % Set y-limits for better visualization

    subplot(3,1,2);
    ezPlot = plot(1:s+1, ez, 'r');
    title('Real-time ez');
    xlabel('Index');
    ylabel('ez');
    ylim([-1 2]); % Set y-limits for better visualization

    subplot(3,1,3);
    ez51 = plot(1:maxtime, ez_51, 'g');
    title('Real-time ez(51)');
    xlabel('Index');
    ylabel('ez51');
    ylim([-1 2]); % Set y-limits for better visualization

    % Time-stepping loop
    for qTime = 1:maxtime
        % Update equations for m = 1 to s
        for m = 1:s-1
            hy(m) = hy(m) + (ez(m + 1) - ez(m)) / imp0;
        end

        for m = 2:s
            ez(m) = ez(m) + (hy(m) - hy(m - 1)) * imp0;
        end
        % Update initial condition for ez
        ez(1) = exp(-(qTime - 30)^2 / 100);
        ez_51(qTime) = ez(51);
        % Update plots with new data
        set(hyPlot, 'YData', hy);
        set(ezPlot, 'YData', ez);
        set(ez51, 'YData', ez_51);

        % Pause to update the plot and make it visible
        pause(0.1); % Adjust the pause duration as needed
        fprintf('%g\n',ez(51));
    end

    % Optionally display a final message or pause
    disp('Simulation complete.');
    disp(['qTime: ', num2str(qTime)]);
    disp(['ez(1): ', num2str(ez(1))]);
    disp(['hy(1): ', num2str(hy(1))]);
    disp(['ez(51): ', num2str(ez(51))]);
    % disp(['ez_51: ', num2str(ez_51)]);

end
