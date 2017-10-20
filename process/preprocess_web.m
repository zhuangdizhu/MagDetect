%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Zhuangdi Zhu @ Michigan State University
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function preprocess_web(filename)
    clear;close all
    cd '/Users/zhuzhuangdi/Desktop/MagDetect/collect'
    input_dir  = '../data/gen/';
    output_dir = '../data/mat/';


    %% --------------------
    %% Variable
    %% --------------------
    DEBUG1 = 1;     % for printing
    DEBUG2 = 1;     % for plotting
    webMags = {};
     
    openInterval = 10; 

    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, filename = '20171020.exp01';end

    %% --------------------
    %% Main starts
    %% --------------------

    %% --------------------
    %% Read Event Time
    %% --------------------
    if DEBUG1, fprintf('Read Event Time\n'); end

    event_time = load([input_dir filename '.time.txt']);  
    
    event_num = unique(sort(event_time(:,2)))
    fprintf('  # event nums: %d\n', length(event_num)); 


    %% --------------------
    %% Read Mag
    %% --------------------
    if DEBUG1, fprintf('Read Mag\n'); end

    mags = load([input_dir filename '.mag.txt']);     
    fs = round(size(mags,1) / (mags(end,1) - mags(1,1)));    
    fprintf('  # freq: %d Hz\n', fs); 
    fprintf('  # Magnetic data loaded, press any key to continue or use Ctrl-C to stop\n');
    
    pause;
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
    
    new_mags = centerize_data(mags);

    %% --------
    %% Seperate Start Events
    %% --------
    
    if DEBUG1, fprintf('Find Start Event\n'); end 
    for idx = 1:size(event_num,1)
        webMags{idx} = {};
        current_start_idx = find(mags(:,1) > event_time(idx,1), 1);
        current_start_time = mags(current_start_idx,1);
        event_type = event_time(idx, 2);
        start_idx = find(new_mags(:,1) >= current_start_time, 1, 'first');
        end_idx = find(new_mags(:,1) >= current_start_time + openInterval, 1, 'first');
        mag_trace = new_mags(start_idx:end_idx-1,[1,5]); 
        %% Centerize Each Mag Trace
        for i = 1:2
            mag_trace(:,i)=mag_trace(:,i)-min(mag_trace(:,i));
        end
        mag_trace(:,2)=mag_trace(:,2)/max(mag_trace(:,2));
        
        %% Zero-pad or truncate each mag_trace so that they are in the same length.
        mag_trace = pad_data(mag_trace,fs,openInterval);
        webMags{event_type}{end+1} = mag_trace;
        if DEBUG2, drawMag(mag_trace); end 
    end 
    %length(mag_traces)
         
    save ([output_dir filename 'mag_trace.mat'], 'webMags', '-mat');
end
  
function [mags] = centerize_data(mags)
    for mi = 2:4
        mags(:,mi) = mags(:,mi) - mean(mags(:,mi));
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
    [N,M] = size(mags);
    figure 
    if M == 2     
        plot(mags(:,1), mags(:,2));
    else 
        plot(mags(:,1), mags(:,5));
    end
    % PLOT
    xlabel('Time');
    ylabel('Magnitude');
    title('EM Magnitued');
    %%%%%%
end