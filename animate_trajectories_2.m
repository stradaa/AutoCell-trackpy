% 1-19-2022, modified from Alex's script
% save current track data from chemotaxitool in excel spreadsheets, and
% save as ".xlsx". Will create movies, each for a spreadsheet
% and save as "sheetname_animation.avi" in the same folder.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPARE MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear, close all

%Input working directory where the Animation.xlsx locates and creat an avi
%file to save a movie

[file,path] = uigetfile('*.xlsx'); % Getting File

%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale = 0.61; % pixel per um  
interval = 0.5; % time between frames in minutes

sheets = sheetnames(file);

%% Animation %%

for i = 1:length(sheets) % loop sheet
   % collecting the data and specifying
   data = xlsread(file,sheets(i));
   cells = data(:,2);
   frames = data(:,3);
   
   % getting fundamental data
   xy_data = data(:,4:5); % [x, y]
   xy_data = xy_data*scale; % pix to um
   num_of_cells = max(cells);
   frames_per_cell = max(frames);
   T = interval*(0:frames_per_cell-1);
   
   % changing format of data into frame by cell array
   ranges = 1:frames_per_cell:length(xy_data); % ranges to split xy_data
   k = 1; % first cell
   for ii = ranges
       upper = ii+frames_per_cell-1;
       data_per_cell{k} = xy_data(ii:upper,:);
       k = k+1;
   end
   
   % plotting and getting num_of_cells # of animated lines
   x_bounds = [min(xy_data(:,1)),max(xy_data(:,1))];
   y_bounds = [min(xy_data(:,2)),max(xy_data(:,2))];
   h = create_animation_lines(num_of_cells, x_bounds, y_bounds);
   for j = [1:frames_per_cell]
       index = 1;
       for ii = h
           addpoints(h{index},data_per_cell{index}(j,1),data_per_cell{index}(j,2));
           index = index + 1;
%            drawnow limitrate 
       end
       % modyfing plot per frame
       title(['T = ',num2str(T(j)), ' Min'],'Fontsize',12);% add title as time
       % taking snapshot of each frame
       F(j) = getframe(gcf); 
   end
   
   % create an avi file as "sheetname"_animation
   saved_file = strcat(sheets(i), '_animation.avi');
   
   % saving .avi
   video = VideoWriter(saved_file, 'Uncompressed AVI');
   video.FrameRate = 30;
   
   % Open the VideoWriter object, write the movie, and close the file
   open(video)
   writeVideo(video, F)
   close(video)
   
   % closing plotted figure of each sheet
   close
end

disp("Done!")
%% Functions Used

% create_animation_lines creates number of animated lines into cells
function h = create_animation_lines(num_of_cells, range_x, range_y)
    for i = 1:num_of_cells
        h{i} = animatedline('Color', rand(1,3), "LineWidth", 0.5); % random color
    end
    set(gca, 'XLim', range_x, 'YLim', range_y)
    grid on;
    xlabel('x [units]');
    ylabel('y [units]');
end

