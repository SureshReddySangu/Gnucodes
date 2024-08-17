% in this code we are not storing the fied ins anpshots we are just adding a additive source,
% and we had removed the absorbing boundary layer here,
% and we ahve added the absorbing boundary layer to ez
% and we are going to add total field/ scatter field boundary
% we are also adding some inhomgenious to the code, t get scattering of the field
% we adding the lossy medium in thsi code
function code6(imp0)
    close all;
    clc;
    clear;

    % Define parameters
    s = 200;          % Size of the array
    imp0= 377.0;      % Magnetic constant
    maxtime = 450;     % Maximum time or simulation duration
    loss = 0.01;       % lossy dielectric constant
    loss_layer = 180; % lossy dielectric constant
    
    % Initialize arrays
    ez = zeros(1, s+1); % ez array of size (s+1) for 1-based indexing
    hy = zeros(1, s);   % hy array of size s for 1-based indexing
    ez_51 = zeros(1, maxtime); % ez array of size (s+1) for 1-based indexing
    ez_overtime = zeros(maxtime, s+1); % ez array of size (s+1) for 1-based indexing
    ceze = zeros(1, s+1); % Initialize ceze
    cezh = zeros(1, s); % Initialize cezh
    chyh(1:s)=377.0;
    chye(1:s)=377.0;

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
    %seting the realtive permittivity of the medium & ez coeffiencts
    for m = 1:s
        if m<101 % free space
            ceze(m) = 1;
            cezh(m) = imp0;
        elseif m<loss_layer 
            ceze(m) =1.0;
            cezh(m) = imp0/9;
        else % lossy dielectric
            ceze(m) = (1- loss)/(1 + loss);
            cezh(m) = imp0/9/(1 + loss);
        end
    end 

    %setting the magnetic coefficets
    for m = 1:s-1
        if m<loss_layer
            chyh(m) =1;
            chye(m) =1/imp0;
        else
            chyh(m) =(1-loss)/(1+loss);
            chye(m) =1/imp0/(1+loss);
        end
    end
    % Time-stepping loop
    for qTime = 1:maxtime
        
        % Update equations for m = 1 to s  for magnetic field
        for m = 1:s-1
            hy(m) = chyh(m)*hy(m) + chye(m)*(ez(m + 1) - ez(m));
            
        end
        % correction for hy to TFSF boundary layer
        hy(50) = hy(50)- exp(-(qTime - 30)^2 / 100)/imp0;
        % update of ez for aborsbing boundary layeer
        ez(1)=ez(2);
        
        % Update teh electric field for m = 1 to s
        for m = 2:s-1
            ez(m) = ceze(m)*ez(m) + (cezh(m)*(hy(m) - hy(m - 1)));
            
        end
        % correction for ez to TFSF boundary layer
        ez(51) = ez(51) + exp(-(qTime+0.5 -(0.5)-30)^2 / 100);
        
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

