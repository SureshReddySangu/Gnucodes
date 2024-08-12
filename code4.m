% in this code we are not storing the fied ins anpshots we are just adding a additive source,
% and we are adding the aborsbing boundary layer,
% and we are going to add total field/ scatter field boundary
% we are also adding some inhomgenious to the code, t get scattering of the field
function code4(imp0)
    close all;
    clc;
    clear;

    % Define parameters
    s = 200;          % Size of the array
    imp0= 377.0;      % Magnetic constant
    maxtime = 450;     % Maximum time or simulation duration
    
    % Initialize arrays
    ez = zeros(1, s+1); % ez array of size (s+1) for 1-based indexing
    hy = zeros(1, s);   % hy array of size s for 1-based indexing
    ez_51 = zeros(1, maxtime); % ez array of size (s+1) for 1-based indexing
    ez_overtime = zeros(maxtime, s+1); % ez array of size (s+1) for 1-based indexing
    
    % Create figures and axes for real-time plotting
        figure(1);
        subplot(3,1,1);
        hyPlot = plot(1:s, hy, 'b');
        title('Real-time hy');
        xlabel('Index');
        ylabel('hy');
        % ylim([-0.02 0.02]); % Set y-limits for better visualization

        subplot(3,1,2);
        ezPlot = plot(1:s+1, ez, 'r');
        title('Real-time ez');
        xlabel('Index');
        ylabel('ez');
        % ylim([-1 2]); % Set y-limits for better visualization

        subplot(3,1,3);
        ez51 = plot(1:maxtime, ez_51, 'g');
        title('Real-time ez(51)');
        xlabel('Index');
        ylabel('ez51');
        % ylim([-1 2]); % Set y-limits for better visualization
    
    % iniatilization of electric field
    for m = 1:s
        ez(m) = 0;
    end
    % iniatilization of hy
    for m = 1:s-1
        hy(m) = 0;
    end
    %seting the realtive permittivity of the medium
    for m = 1:s
        if m<101
            eps(m) = 1;
        else 
            eps(m) = 9.0;
        end
    end 



    % Time-stepping loop
    for qTime = 1:maxtime
        %Upating hy for aborsbing boundary layeer
        hy(s)= hy(s-1);
        % Update equations for m = 1 to s  for magnetic field
        for m = 1:s-1
            hy(m) = hy(m) + (ez(m + 1) - ez(m)) / imp0;
            % correction for hy to TFSF boundary layer
            hy(50) = hy(50)- exp(-(qTime - 30)^2 / 100)/imp0;
        end
        % update of ez for aborsbing boundary layeer
        ez(1)=ez(2);
        ez(s)=ez(s-1);
        % Update teh electric field for m = 1 to s
        for m = 2:s
            ez(m) = ez(m) + (hy(m) - hy(m - 1)) * imp0 /eps(m);
            % correction for ez to TFSF boundary layer
            ez(51) = ez(51) + exp(-(qTime+0.5 -(0.5)-30)^2 / 100);
        end
        % Update initial condition for ez
        %ez(1) = exp(-(qTime - 30)^2 / 100);
        % use of additive source intialization at t=30 or node 51
        ez(51) = ez(51) + exp(-(qTime - 30)^2 / 100);
        ez_51(qTime) = ez(51);
        ez_overtime(qTime,:) = ez; %store ez in ez_overtime

        

        % Update plots with new data
        set(hyPlot, 'YData', hy);
        set(ezPlot, 'YData', ez);
        set(ez51, 'YData', ez_51);

        % Pause to update the plot and make it visible
        pause(0.1); % Adjust the pause duration as needed
        fprintf('%g\n',ez(51));

        
    end

    disp('Simulation complete.');
    disp(['qTime: ', num2str(qTime)]);
    disp(['ez(1): ', num2str(ez(1))]);
    disp(['hy(1): ', num2str(hy(1))]);
    disp(['ez(51): ', num2str(ez(51))]);
    % disp(['ez_51: ', num2str(ez_51)]);

    %creating waterfall plot
        figure(3);
        [X, Y] = meshgrid(1:s+1, 1:maxtime); % genreate grif for plotting
        waterfall(X, Y, ez_overtime); % plot waterfall
        title('Waterfall plot');
        xlabel('Index');
        ylabel('Time');
        zlabel('ez');
        grid on;
        colormap(jet(256));
        colorbar;


end



