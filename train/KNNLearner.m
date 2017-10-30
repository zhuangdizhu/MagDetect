function [test_labels,confidences] = KNNLearner(selfFlag, test_data ,train_data,train_labels, K)

n_train = size(train_labels,1);
n_test = size(test_data,1);
app_cnt = length(unique(train_labels));

test_labels = zeros(n_test,1);
confidences = [];

for i = 1:size(test_data,1)  
    ret_matrix = zeros(n_train,1);
    test_ts = test_data(i,:)'; 
    for j = 1:size(train_data,1)
        if selfFlag == 1 && i == j
            ret_matrix(j) = -1;continue;
        end
        train_ts = train_data(j,:)';
        
        %%%%%%%%%%%%%%%synchronization%%%%%%%%%%%%%%%%%
        %test_ts = cross_correlation(train_ts,test_ts);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%calculate distance%%%%%%%%%%%%%%%%
        r = (test_ts-train_ts)'*(test_ts-train_ts);
        r = sqrt(r/length(test_ts));  
        r = 1/r;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        ret_matrix(j) = r;   
    end
    [~,ID] = sort(ret_matrix,'descend'); 
    ID = ID(1); 
    
    test_labels(i,:) = train_labels(ID);  
    train_ts = train_data(ID,:);
    confidences(i,:) = abs(corr2(train_ts',test_ts));
end 

if K ~= 1
    for i = 1:length(confidences)
        curr_conf = confidences(i);
        if curr_conf < 0.5
            test_labels(i) = app_cnt+1;
        end
    end
end
end