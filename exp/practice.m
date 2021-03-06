%Presents images in fMRI experiment
%Record responses of face/house task.
try
    clear all;
    close all;
    clc;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference','SkipSyncTests', 1);
    setupmainexp;     
    %% Prepare Screen for Experiment
    %HideCursor;
    %%Prep Screen
    screenNumber=max(Screen('Screens'));
    black=BlackIndex(screenNumber);
    gray=GrayIndex(screenNumber);
    white=WhiteIndex(screenNumber);
    green = [0 255 0];
    red = [255 0 0];
    %[window,screenRect]=Screen('OpenWindow',screenNumber,gray,[],8,2); % full SCREEN mode, in mid-level gray
    
    [window,screenRect]=Screen('OpenWindow',0, gray);
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);
    ifi = Screen('GetFlipInterval', window); % an estimate of the monitor flip interval
    Screen('TextSize', window,40);
    %SETUP RECTS FOR IMAGE
    facerect = [0 0 stimwidth stimheight]/1.5;
    center=screenRect(3:4)/2;
    fix=15;
    fix_w=5;
    box=1;
    cue_w=5;
    loc = CenterRect(facerect, screenRect);
    %% Prep Port
    if ~DEBUG
        [P4, openerror] = IOPort('OpenSerialPort', 'COM6','BaudRate=19200'); %opens port for receiving scanner pulse
        IOPort('Flush', P4); %flush event buffer
    end
    % SHOW READY TEXT
    DrawFormattedText(window, waitingtext, 'center', 'center', white);
    Screen('Flip', window); % Shows 'READY'
    % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
    %% START TRIALS  
    trial = 1;
    presentations = zeros(totalNum,9);
    botpress = zeros(totalNum,1);
    timepress = zeros(totalNum,1);
    % Prep Port
    while 1
        if ~DEBUG
            [pulse,temptime,readerror] = IOPort('read',P4,1,1);
            scanstart = GetSecs;
        else
            [keyIsDown,secs,keyCode] = KbCheck;
            start_key = KbName('space'); % press space to start the trial
            if keyCode(start_key) % If 5 is pressed on the keyboard (win: 53; mac: 93) using KbName('5')
                pulse = start_key;
            end
            scanstart = GetSecs;
        end
        if ~isempty(pulse) && (pulse == start_key)
            break;
        end
    end
    Screen('Flip', window); % Shows fixation and box
    begintime = GetSecs; % experiment start time
    while GetSecs - begintime < fixationtime % 4 s for the first fixation
    end
    while trial <= totalNum
        % Pre the 1st stimulus
        % 3 is conetent nat(1)/urb(2); 4 is layout open(1)/close(2); 6 is
        % examplar 1/2; 5 is repatition repeated(1) non-repeated(2)
        if conditions(trial,3) == 1 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 1
            Screen('PutImage', window, nat_ope_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 1
            Screen('PutImage', window, nat_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 1
            Screen('PutImage', window, nat_clo_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 1
            Screen('PutImage', window, nat_clo_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 1
            Screen('PutImage', window, urb_ope_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 1
            Screen('PutImage', window, urb_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 1
            Screen('PutImage', window, urb_clo_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 1
            Screen('PutImage', window, urb_clo_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 2
            Screen('PutImage', window, urb_clo_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 2
            Screen('PutImage', window, urb_clo_1, loc);
            Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 2
            Screen('PutImage', window, urb_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 2
            Screen('PutImage', window, urb_ope_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 2
            Screen('PutImage', window, nat_clo_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 2
            Screen('PutImage', window, nat_clo_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 1 && conditions(trial, 5) == 2
            Screen('PutImage', window, nat_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && ...
                conditions(trial, 6) == 2 && conditions(trial, 5) == 2
            Screen('PutImage', window, nat_ope_1, loc);
            %Screen('DrawingFinished', window);
        end
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('DrawingFinished', window);
        %% trial starts
        % 1st stimulus onset
        starttime1 = Screen('Flip', window); % first stimulus onset. starttime1 is the time that the screen 'flipped'
        % set up the time lag between the 1st and 2nd stimulus
        presentations (trial,1:7) = [conditions(trial,:), starttime1];
        Soatime=conditions(trial,2); % in unit of number of frames
        %Soatime = 2;
        % Prep the 1st noise mask
        Screen('PutImage', window, pnoise1, loc);
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('DrawingFinished', window);
        % 1st stimulus offset, noise onset
        offtime1 = Screen('Flip', window, starttime1 + (nFrameSti - 0.5)*ifi); % the first stimulus presented for 6 frames
        % 1st noise offset
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('Flip', window, offtime1 + (2 - 0.5)*ifi);
        % Prep the 2nd stimulus
        
        % 3 is conetent nat(1)/urb(2); 4 is layout open(1)/close(2); 6 is
        % examplar 1/2
        if conditions(trial,3) == 1 && conditions(trial,4)==1 && conditions(trial, 6) == 1
            Screen('PutImage', window, nat_ope_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==1 && conditions(trial, 6) == 2
            Screen('PutImage', window, nat_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && conditions(trial, 6) == 1
            Screen('PutImage', window, nat_clo_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 1 && conditions(trial,4)==2 && conditions(trial, 6) == 2
            Screen('PutImage', window, nat_clo_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && conditions(trial, 6) == 1
            Screen('PutImage', window, urb_ope_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==1 && conditions(trial, 6) == 2
            Screen('PutImage', window, urb_ope_2, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && conditions(trial, 6) == 1
            Screen('PutImage', window, urb_clo_1, loc);
            %Screen('DrawingFinished', window);
        elseif conditions(trial,3) == 2 && conditions(trial,4)==2 && conditions(trial, 6) == 2
            Screen('PutImage', window, urb_clo_2, loc);
            %Screen('DrawingFinished', window);
        end
        
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('DrawingFinished', window);
        % 2nd stimulus onset
        starttime2 = Screen('Flip', window, offtime1 + (Soatime - 0.5)*ifi);
        
        % Prep the 2nd noise mask
        Screen('PutImage', window, pnoise1, loc);
        Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('DrawingFinished', window);
        
        % 2nd stimulus offset, noise onset
        offtime2 = Screen('Flip', window, starttime2 + (nFrameSti-0.5)*ifi);
        Screen('DrawLine',window,green,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
        Screen('DrawLine',window,green,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
        Screen('Flip', window);
        
        % record response
        if ~DEBUG
            while 1
                while 1
                    pulse=IOPort('read',P4,0,1);
                    if ~isempty(pulse) && (pulse ~= 53)
                        botpress(trial,1)=pulse;
                        timepress(trial,1)=GetSecs-starttime2;
                        break
                    end
                    if GetSecs-starttime1>=fixationtime-0.5
                        break
                    end
                end
                if GetSecs-starttime1>=fixationtime-0.5
                    break
                end
            end
        else
            while 1
                while 1
                    [keyIsDown,secs,keyCode] = KbCheck;
                    pulse = find(keyCode);
                    if ~isempty(pulse) && (pulse ~= 53)
                        botpress(trial,1)=pulse;
                        timepress(trial,1)=GetSecs-starttime2;
                        break
                    end
                    if GetSecs-starttime1>=fixationtime % w
                        break
                    end
                end
                if GetSecs-starttime1>=fixationtime
                    break
                end
            end
        end
        %% trial ends
        % Prep for next trial
        presentations (trial,8) = offtime1;
        presentations (trial,9) = starttime2;
        trial = trial+1;
        
    end
     % Prep for last Fixation
    endtime1 = GetSecs; 
    % Prep Fixation
    Screen('DrawLine',window,white,center(1)-fix,center(2),center(1)+fix,center(2),fix_w);
    Screen('DrawLine',window,white,center(1),center(2)-fix,center(1),center(2)+fix,fix_w);
  
    Screen('Flip', window); % Shows fixation
    while GetSecs - endtime1 < fixationtime+0.5
    end
    endtime = GetSecs;
    totalexptime = endtime - begintime;
    presentations(:, 10) = presentations(:,9)-presentations(:,8);
    presentations(:, 11) = round(presentations(:,10)/ifi);
    save(sprintf('./data/data_%s.mat', sid), 'presentations', 'botpress','timepress');
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor;
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');
X = ['This run is ', num2str(totalexptime), ' seconds.'];
disp(X);