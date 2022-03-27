% 1-15-2022, modified from Alex's script
% save current track data from chemotaxitool in excel spreadsheets, and
% save as "for animation.xlsx". Will create movies, each for a spreadsheet
% and save as "sheetname_animation.avi" in the same folder.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPARE MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc, clear, close all

%Input working directory where the Animation.xlsx locates and creat an avi
%file to save a movie

P = 'Input your current working directory here... ';
P = input(P,'s');
P = strcat(P,'\');

%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale = 0.61; % pixel per um  
interval = 0.5; % time between frames in minutes

Inputfile = strcat(P,'for animation (1).xlsx');
sheet = sheetnames(Inputfile);

for jj = 1:length(sheet) %loop sheet
    data = xlsread(Inputfile, jj);%load sheet and import data into matlab
    cells = data (:,2);
    times = data (:,3);
    x = data (:,4);
    x = scale*x; %pix to um
    y = data (:,5);
    y = scale*y; %pix to um
    num_of_cells = max(cells);
    frames_per_cell = max(times);
    T = interval*(0:frames_per_cell-1);
    X = reshape(x,frames_per_cell,num_of_cells); %convert x into frame by cell array
    Y = reshape(y,frames_per_cell,num_of_cells); %convert y into frame by cell array
    
    figh = figure;
    clf
    %set(gcf,'Color','w','Position', [0 0 400 400]); % set background and size
    %set(gca,'Xlim', [min(X,[],'all') max(X,[],'all')], 'Ylim', [min(Y,[],'all') max(Y,[],"all")],'Color','k');% axis scale and color
    set(gca,'Xlim', [min(x) max(x)],'Ylim', [min(y) max(y)]);
    xlabel('X [um]');
    ylabel('Y [um]');
    grid on;

    h = animatedline; % establish an animated object
    
    for i = 1:frames_per_cell %loop each frame
        for k = 1:num_of_cells %loop each cell   
            h.LineWidth = 0.5;
            h.Color = rand(1,3);
            addpoints(h, X(i,k), Y(i,k)); % add current point
            hold on;
        end
    
        hold off;
            
        % modify the plot
        title(['T = ',num2str(T(i)), ' Min'],'Fontsize',12);% add title as time
    
        %Take a Snapshot
        F(i) = getframe (figh);
    end
    
    %create an avi file as "sheetname"_animation
    sheetname = sheet(jj);
    Savefile = strcat(P,sheetname,'_animation.avi');

    %Create a VideoWriter object and set properties
    myWriter = VideoWriter(Savefile, 'Uncompressed AVI'); %create an .avi file
    myWriter.FrameRate = 20; %20 frame per second
    
    %Open the VideoWriter object, write the movie, and close the file
    open(myWriter);
    writeVideo(myWriter, F);
    close(myWriter);
    close

end
disp ("Done!")


