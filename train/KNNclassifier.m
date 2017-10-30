%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  
%% Zhuangdi Zhu @ Michigan State University 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function KNNclassifier()
    clc;clear;close all 
    cd /Users/zhuzhuangdi/Desktop/MagDetect/train
    
    %% Input Variables 
    
    input_dir = '../data/train/';
    input_filename1 = 'training_data_1';
    read_file = [input_dir input_filename1 '.mat'];
    load(read_file, 'train_data', 'train_labels');
    length(unique(train_labels))
    
    %% Train & Test, for 10 times
    %%{
    accuracy12 = zeros(1,10); accuracy21 = zeros(1,10); 
    for i = 1:10
        n = size(train_data,1);
        idx1 = datasample(1:n, n*0.5, 'Replace', false);
        idx2 = setdiff(1:n,idx1);

        data1 = train_data(idx1,:);
        labels1 = train_labels(idx1,:);

        data2 = train_data(idx2,:);
        labels2 = train_labels(idx2,:);

        model1 = fitcknn(data1, labels1,'NumNeighbors',1); 
        predict12 = predict(model1, data2);
        acc12 = length(find(predict12 ~= labels2)) / size(data2,1)
        accuracy12(i) = acc12;
        model2 = fitcknn(data2, labels2,'NumNeighbors',1);
        predict21 = predict(model2, data1);
        acc21 = length(find(predict21 ~= labels1)) / size(data1,1)
        accuracy21(i) = acc21;
    end
    max_acc21 = max(accuracy21);
    avg_acc21 = mean(accuracy21);
    
    max_acc12 = max(accuracy12);
    avg_acc12 = mean(accuracy12);
    
    fprintf('train-data2, test-data1:\n Max Accuracy %.3f, Avg Accuracy %.3f\n', max_acc21,avg_acc21);
    fprintf('train-data1, test-data2:\n Max Accuracy %.3f, Avg Accuracy %.3f\n', max_acc12,avg_acc12);
    
    %VisualizeFeature(train_data, 20)
end

function VisualizeFeature(samples, chunkSize)
    n = size(samples,1);
    chunk = n/chunkSize;
    for i = 1:chunkSize
        figure 
        plot(samples(i,:))
        hold on
        for j = 2:chunk 
            row_id = i+chunkSize*(j-1);
            plot(samples(row_id,:))
        end
    end
end
 
  