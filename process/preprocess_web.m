%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Zhuangdi Zhu @ Michigan State University
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function preprocess_web(RELOAD, input_filename, output_filename)
    clc;close all
    cd '/Users/zhuzhuangdi/Desktop/MagDetect/collect'
    input_dir  = '../data/gen/';
    output_dir = '../data/train/';


    %% --------------------
    %% Variable
    %% --------------------
    DEBUG1 = 1;     % for printing
    DEBUG2 = 0;     % for plotting 
    
    if nargin < 3
    RELOAD = 1;     % re-write data if 1; else append to original data  
    input_filename = '20171027.exp01';
    output_filename = 'training_data_1';
    end
    
    train_data = [];
    train_labels = []; 
    openInterval = 10; 
    %% --------------------
    %% Read Event Time
    %% --------------------
    if DEBUG1, fprintf('Read Event Time\n'); end

    event_time = load([input_dir input_filename '.time.txt']);  
    
    event_num = unique(sort(event_time(:,2)));
    fprintf('  # event nums: %d\n', length(event_num)); 


    %% --------------------
    %% Read Mag
    %% --------------------

    mags = load([input_dir input_filename '.mag.txt']);     
    fs = round(size(mags,1) / (mags(end,1) - mags(1,1)));    
    if DEBUG1
        fprintf('Read Mag\n');
        fprintf('  # freq: %d Hz\n', fs); 
        fprintf('  # Magnetic data loaded, press any key to continue or use Ctrl-C to stop\n'); 
        %pause;
    end
    %%%%%%
    
    %% Sythesized signal
    mags(:,5) = sqrt(mags(:,2).^2 + mags(:,3).^2 + mags(:,4).^2);
    
    %% PLOT
    if DEBUG2
        drawMag(mags); 
        fprintf('  # Raw data ploted, press any key to continue or use Ctrl-C to stop\n');
        pause;
    end 
    
    %% Centerize Data; Remove Earth Impact
    if DEBUG1, fprintf('Centerize Mag Data\n'); end
    
    new_mags = centerize_3D_data(mags);

    %% --------
    %% Seperate & Save Each Events
    %% --------
    
    if DEBUG1, fprintf('Seperate & Save Events ...\n'); end  
    
    for idx = 1:size(event_time,1)
        web_id = event_time(idx,2);
        
        current_start_idx = find(mags(:,1) > event_time(idx,1), 1);
        current_start_time = mags(current_start_idx,1);
        
        start_idx = find(new_mags(:,1) >= current_start_time, 1, 'first');
        end_idx = find(new_mags(:,1) >= current_start_time + openInterval, 1, 'first');
        
        mag_trace = new_mags(start_idx:end_idx-1, 5); 
        
        %% 0-1 normalize Each Mag Trace
        mag_trace = mag_trace - min(mag_trace);
        mag_trace = mag_trace / max(mag_trace);
        
        %% Zero-pad or truncate each mag_trace so that they are in the same length.
        if fs ~= 100 
            fprintf('fs= :%d\n', fs);
            %pause
            fs = 100;
        end
        
        mag_trace = pad_data(mag_trace,fs,openInterval); 
        
        %% Append each mag_trace to train_data array.
        train_data(end+1,:) = mag_trace';
        train_labels(end+1,:) = web_id;  
        
        %% Plot the mag trace if you you want 
        if DEBUG2, drawMag(mag_trace); end 
    end 
    
    %% Save training samples to file
    write_file = [output_dir output_filename '.mat'];
    if RELOAD == 1 
        save(write_file, 'train_data', 'train_labels');
    else
        cur_train_data = train_data;
        cur_train_labels = train_labels; 
        load(write_file, 'train_data', 'train_labels');
        train_data = [train_data;cur_train_data];
        train_labels = [train_labels;cur_train_labels];
        save(write_file, 'train_data', 'train_labels');
    end
    
    if DEBUG1, fprintf('Training Data Saved.\n'); end 
end
  
function [mags] = centerize_3D_data(mags)
    for mi = 2:4
        mags(:,mi) = mags(:,mi) - min(mags(:,mi));
    end
    mags(:,5) = sqrt(mags(:,2).^2 + mags(:,3).^2 + mags(:,4).^2);
    
end
function [mags] = pad_data(mags,fs,interval)
    n = size(mags,1);
    len = fs * interval;
    if n > len
        mags = mags(1:len,:);
    else 
        for x = n+1:len
            mags(x,:) = mags(end,:);
        end
    end
end

function drawMag(mags)
    M = size(mags,2);
    figure 
    if M == 1     
        plot(mags(:,1));
    elseif M == 5
        plot(mags(:,1), mags(:,5));
    end
    % PLOT
    xlabel('Time');
    ylabel('Magnitude');
    title('EM Magnitued');
    %%%%%%
end