%%%% CALLBACK FUNCTION FOR CLIENTMAIN TIMER


function timerCallback(obj, event) 

    %av_period = get(obj, 'AveragePeriod')
    fprintf("Timer callback executed. %f seconds since last call\n", get(obj, 'InstantPeriod'));
    
    %%%%%%%%%%%%%% CONDITIONAL EXECUTIONS %%%%%%%%%%%%%%
    
    
    %------------- send commands to robot --------------------
    % 1) check the command queue to see if there is a command waiting
    % 2) send command via tcp and remove it from the command queue
    
    
    %---------- request status of i/o via tcp from robot -----
    % 1) send a request packet to the robot
    % 2) receive the i/o packet from the robot
    
    
    %---------- receive tcp from camera ---------------------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the camera plot
    
    
    %---------- receive tcp from conveyor camera -----------
    % 1) receive the tcp
    % 2) use gui plot handle for setting the data in the camera plot
    
    
    
    
    %%%%%%%%%%%%%% EXIT PROGRAM CONDITION %%%%%%%%%%%%%%%%%%%
    
    %exit button pressed, stop the timer
    global exit;
    if(exit == true)
        disp("stopping");
        stop(obj);
    end

end

