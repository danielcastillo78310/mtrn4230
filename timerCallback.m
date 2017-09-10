%%%% CALLBACK FUNCTION FOR CLIENTMAIN TIMER


function timerCallback(obj, event, ui) 

    %av_period = get(obj, 'AveragePeriod')
    %fprintf('Timer callback executed. %f seconds since last call\n', get(obj, 'InstantPeriod'));
    
    %% %%%%%%%%%%%% CONDITIONAL EXECUTIONS %%%%%%%%%%%%%%
    
    %%------------- send commands to robot --------------------
    % 1) check the command queue to see if there is a command waiting
    % 2) send command via tcp and remove it from the command queue
    
    
    %% ---------- request status of i/o via tcp from robot -----
    % 1) send a request packet to the robot
    % 2) receive the i/o packet from the robot
    % 3) update status of i/o s
    
    %currently fills io status on gui to junk data
    
    ui.updateIOs(ui.IOs);
    
    %% ---------- request pose of the robot and update ui ------
    % 1) send request packet to robot
    % 2) receive the packet from the robot
    % 3) update interface
    
    ui.pose = ui.robotTCP.requestPose();
    ui.updatePose(ui.pose(1), ui.pose(2), ui.pose(3), ui.pose(4:9));
    
    
    
    %% ---------- receive serial from conveyor camera ---------------------
    % 1) receive the serial data
    % 2) use gui plot handle for setting the data in the conveyor camera plot
    try
        ui.datafromConveyorCam();
        set(ui.h_camConveyor, 'CData', ui.conveyorRGB);
    catch
        set(ui.h_camConveyor, 'CData', NaN(1600, 1200));
    end
    
    % 2) use gui plot handle for setting the data in the camera plot
    %set(ui.h_textConveyor, 'position', [150 150], 'String', 'here');
    
    %% ---------- receive tcp from table camera -----------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the table camera plot
    s = sprintf('IMG_0%02d.jpg',round(randi([1 99],1,1)));
    try
       I = imread(s);
    catch
       I = imread('IMG_005.jpg');
    end
    
    try
        ui.datafromTableCam();
        %set(ui.h_camTable, 'CData', ui.tableRGB);
        set(ui.h_camTable,'CData', I);
    catch
        set(ui.h_camTable, 'CData', NaN(1600, 1200));
    end
    
    blocks = detect_blocks(I);
    string_out = Update_TableHdl(blocks);
    
    set(ui.h_plotTable,'xdata',blocks(:,1),'ydata',blocks(:,2));
    set(ui.h_textTable, 'position', [blocks(:,1) blocks(:,2)], 'String', string_out);
        
    %%----------- execute queued commands (added by GUI) ------
    ui.nextCommand();
    
    %% %%%%%%%%%%%% EXIT PROGRAM CONDITION %%%%%%%%%%%%%%%%%%%
    
    %exit button pressed, stop the timer
    global exit;
    if(exit == true)
        disp('stopping');
        stop(obj);
    end

end


function textoutput = Update_TableHdl(c)
    %Produce Strings for text output theta, colour, shape, upper_surface, reachable
    if (~isempty(c))
        for i=1:size(c,1)
            orientation = string(c(i,3));
            if c(i,4) == 1
                colour = 'red';
            elseif c(i,4) == 2
                colour = 'orange';
            elseif c(i,4) == 3
                colour = 'yellow';
            elseif c(i,4) == 4
                colour = 'green';
            elseif c(i,4) == 5
                colour = 'blue';
            elseif c(i,4) == 6
                colour = 'purple';
            elseif c(i,4) == 0
                colour = 'inverted';
            end
            if c(i,5) == 1
                shape = 'square';
            elseif c(i,5) == 2
                shape = 'orange';
            elseif c(i,5) == 3
                shape = 'yellow';
            elseif c(i,5) == 4
                shape = 'green';
            elseif c(i,5) == 5
                shape = 'blue';
            elseif c(i,5) == 6
                shape = 'purple';
            elseif c(i,5) == 0
                shape = 'inverted';
            end
            if c(i,6) == 1
                uppersurface = '1';
            elseif c(i,6) == 2
                uppersurface = '2';
            end
            if c(i,7) == 1
                reachable = '1';
            elseif c(i,7) == 0
                reachable = '0';
            end
            textoutput(i) = sprintf('%s,%s,%s,%s,%s',orientation,colour,shape,uppersurface,reachable);
        end
    else
        textoutput = '';
    end
end