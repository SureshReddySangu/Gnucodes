%in this code, we will store teh field in snapshots and we are adding a additive source
function code2(imp0)
    close all;
    clc;
    clear;

    % Define parameters
    s = 200;          % Size of the array
    imp0= 377.0;      % Magnetic constant
    maxtime = 200;     % Maximum time or simulation duration
    basename = 'sim';    % Base name for output files
    frame =0; %frame number
    filestoplt = 3; % no fo the plots to be plotted from the written sim.outpt files
    outputDir = 'simOutput';%Directory for output files
    % Initialize arrays
    ez = zeros(1, s+1); % ez array of size (s+1) for 1-based indexing
    hy = zeros(1, s);   % hy array of size s for 1-based indexing
    ez_51 = zeros(1, maxtime); % ez array of size (s+1) for 1-based indexing
    
    %Initialize arrays for sim.txt files plotting
    data = zeros(filestoplt,s);
    xaxis = linspace(1,maxtime);

     % Create output directory if it doesn't exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    % Create figures and axes for real-time plotting
        figure(1);
        subplot(3,1,1);
        hyPlot = plot(1:s, hy, 'b');
        title('Real-time hy');
        xlabel('Index');
        ylabel('hy');
        ylim([-0.02 0.02]); % Set y-limits for better visualization

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
        % Update equations for m = 1 to s  for magnetic field
        for m = 1:s-1
            hy(m) = hy(m) + (ez(m + 1) - ez(m)) / imp0;
        end
        % Update teh electric field for m = 1 to s
        for m = 2:s
            ez(m) = ez(m) + (hy(m) - hy(m - 1)) * imp0;
        end
        % Update initial condition for ez
        %ez(1) = exp(-(qTime - 30)^2 / 100);
        % use of additive source intialization at t=30 or node 51
        ez(51) = ez(51) + exp(-(qTime - 30)^2 / 100);
        ez_51(qTime) = ez(51);
        %write to file if the time is a multiple of 10
        if mod(qTime,10)==0 && qTime>10
            frame = frame+1;
            filename = sprintf('%s/sim.txt.%d',outputDir,frame);
            fid = fopen(filename,'w');
            if fid == -1
                error('Unable to open file');
            end
            %write to file
            for i=1:s
                fprintf(fid,'%g\n',ez(i));
            end
            %close file
            fclose(fid);
            disp('file written');
        end
        % Update plots with new data
        set(hyPlot, 'YData', hy);
        set(ezPlot, 'YData', ez);
        set(ez51, 'YData', ez_51);

        % Pause to update the plot and make it visible
        pause(0.1); % Adjust the pause duration as needed
        fprintf('%g\n',ez(51));

        
    end

    %Read sim.txt files
    filelist = dir(fullfile(outputDir,'sim.txt.*'));
    if length(filelist) < filestoplt
        error('Not enough files in the output directory');
    end
    for i=1:filestoplt
        %construct filename for sim.txt file
        filename = fullfile(outputDir,filelist(i).name);
        %read data from file
        try
            fileData = load(filename);
            %check if the data has read completely
            if length(fileData) ~= s
                warning('Incomplete data read from file');
                continue;
            end
        %store data in data array
        data(i,:) = fileData;

        %confirm that the data is read completely
        fprintf('Read %d data points from file %s\n',length(fileData),filename);
        catch message   
            warning('Error reading file %s',filename);
        end
    end
    %plot teh data from the files
    figure;
    hold on;
    for i=1:filestoplt
        subplot(filestoplt,1,filestoplt-i+1);   
        plot(data(i,:), 'DisplayName',sprintf('sim.txt.%d',i));
        title(sprintf('sim.txt.%d',i));
        %add labels and legend
        xlabel('Time');
        ylabel('ez');
        ylim([0 0.8]); % Set y-limits for better visualization
        legend('show');
        grid on;
    end
    hold off;
    disp('plotting done');
    % Optionally display a final message or pause
    disp('Simulation complete.');
    disp(['qTime: ', num2str(qTime)]);
    disp(['ez(1): ', num2str(ez(1))]);
    disp(['hy(1): ', num2str(hy(1))]);
    disp(['ez(51): ', num2str(ez(51))]);
    % disp(['ez_51: ', num2str(ez_51)]);

end



% %in this code, we will store teh field in snapshots and we are adding a additive source
% function code2(imp0)
%     close all;
%     clc;
%     clear;

%     % Define parameters
%     s = 200;          % Size of the array
%     imp0= 377.0;      % Magnetic constant
%     maxtime = 200;     % Maximum time or simulation duration
%     basename = 'sim';    % Base name for output files
%     frame =0; %frame number
%     filestoplt = 3; % no fo the plots to be plotted from the written sim.outpt files
%     outputDir = 'simOutput';%Directory for output files
%     % Initialize arrays
%     ez = zeros(1, s+1); % ez array of size (s+1) for 1-based indexing
%     hy = zeros(1, s);   % hy array of size s for 1-based indexing
%     ez_51 = zeros(1, maxtime); % ez array of size (s+1) for 1-based indexing
    
%     %Initialize arrays for sim.txt files plotting
%     data = zeros(filestoplt,s);
%     xaxis = linspace(1,maxtime);

%     %Read sim.txt files
%     filelist = dir(fullfile(outputDir,'sim.txt.*'));
%     if length(filelist) < filestoplt
%         error('Not enough files in the output directory');
%     end
%     for i=1:filestoplt
%         %construct filename for sim.txt file
%         filename = fullfile(outputDir,filelist(i).name);
%         %read data from file
%         try
%             fileData = load(filename);
%             %check if the data has read completely
%             if length(fileData) ~= s
%                 warning('Incomplete data read from file');
%                 continue;
%             end
%         %store data in data array
%         data(i,:) = fileData;

%         %confirm that the data is read completely
%         fprintf('Read %d data points from file %s\n',length(fileData),filename);
%         catch message   
%             warning('Error reading file %s',filename);
%         end
%     end
       

%     % Create output directory if it doesn't exist
%     if ~exist(outputDir, 'dir')
%         mkdir(outputDir);
%     end
    

%     % Create figures and axes for real-time plotting
%     figure;
%     subplot(3,1,1);
%     hyPlot = plot(1:s, hy, 'b');
%     title('Real-time hy');
%     xlabel('Index');
%     ylabel('hy');
%     ylim([-0.02 0.02]); % Set y-limits for better visualization

%     subplot(3,1,2);
%     ezPlot = plot(1:s+1, ez, 'r');
%     title('Real-time ez');
%     xlabel('Index');
%     ylabel('ez');
%     ylim([-1 2]); % Set y-limits for better visualization

%     subplot(3,1,3);
%     ez51 = plot(1:maxtime, ez_51, 'g');
%     title('Real-time ez(51)');
%     xlabel('Index');
%     ylabel('ez51');
%     ylim([-1 2]); % Set y-limits for better visualization


%     %plot teh data from the files
%     figure;
%     hold on;
%     for i=1:filestoplt
%         subplot(filestoplt,1,filestoplt-i+1);   
%         plot(data(i,:), 'DisplayName',sprintf('sim.txt.%d',i));
%         title(sprintf('sim.txt.%d',i));
%         %add labels and legend
%         xlabel('Time');
%         ylabel('ez');
%         ylim([0 0.8]); % Set y-limits for better visualization
%         legend('show');
%         grid on;
%     end
%     hold off;
    

%     disp('plotting done');


%     % Time-stepping loop
%     for qTime = 1:maxtime
%         % Update equations for m = 1 to s  for magnetic field
%         for m = 1:s-1
%             hy(m) = hy(m) + (ez(m + 1) - ez(m)) / imp0;
%         end
%         % Update teh electric field for m = 1 to s
%         for m = 2:s
%             ez(m) = ez(m) + (hy(m) - hy(m - 1)) * imp0;
%         end
%         % Update initial condition for ez
%         %ez(1) = exp(-(qTime - 30)^2 / 100);
%         % use of additive source intialization at t=30 or node 51
%         ez(51) = ez(51) + exp(-(qTime - 30)^2 / 100);
%         ez_51(qTime) = ez(51);
%         %write to file if the time is a multiple of 10
%         if mod(qTime,10)==0 && qTime>10
%             frame = frame+1;
%             filename = sprintf('%s/sim.txt.%d',outputDir,frame);
%             fid = fopen(filename,'w');
%             if fid == -1
%                 error('Unable to open file');
%             end
%             %write to file
%             for i=1:s
%                 fprintf(fid,'%g\n',ez(i));
%             end
%             %close file
%             fclose(fid);
%             disp('file written');
%         end
%         % Update plots with new data
%         set(hyPlot, 'YData', hy);
%         set(ezPlot, 'YData', ez);
%         set(ez51, 'YData', ez_51);

%         % Pause to update the plot and make it visible
%         pause(0.1); % Adjust the pause duration as needed
%         fprintf('%g\n',ez(51));
%     end

%     % Optionally display a final message or pause
%     disp('Simulation complete.');
%     disp(['qTime: ', num2str(qTime)]);
%     disp(['ez(1): ', num2str(ez(1))]);
%     disp(['hy(1): ', num2str(hy(1))]);
%     disp(['ez(51): ', num2str(ez(51))]);
%     % disp(['ez_51: ', num2str(ez_51)]);

% end