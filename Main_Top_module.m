clear all;
train_file_read = tdfread('train1000.txt');
training_data=struct2array(train_file_read);
[row,col]=size(training_data);
graph_matrix=zeros(col); %% The array which represents the final graph.
alpha_score=zeros(col,1); %% To get the alpha scores
feature_vectors=zeros(col,4); %%Top 4 nodes connected to given node.
corr_vectors=zeros(col,4);

%%%%To calculate alpha scores described in algorithm
for i=1:20
    alpha_vec=zeros(col,1);
    for j=1:20
    if(i~=j)   
        alpha_vec(j)=abs(corr(training_data(:,i),training_data(:,j)));
    end
    end
    [vals,ftrs]=sort(alpha_vec,'descend');
    corr_vectors(i,1:4)=vals(1:4);
    feature_vectors(i,1:4)=ftrs(1:4);
end

p1=sum(corr_vectors,2);
[correl,order_of_ftrs]=sort(p1,'descend');

corr_vectors=[corr_vectors,p1];
feature_vectors=[feature_vectors,p1];

corr_vectors=sortrows(corr_vectors,-5);
feature_vectors=sortrows(feature_vectors,-5);

corr_threshold=0.2;

%%%Filling the graph matrix%%%
for i=1:20
    index=order_of_ftrs(i);
    %num_of_connections=4-sum(graph_matrix(index,:));
    num_of_connections=2;
    for j=1:num_of_connections
        if(corr_vectors(i,j)>corr_threshold)
            if(sum(graph_matrix(feature_vectors(i,j),:))<4)
            graph_matrix(feature_vectors(i,j),index)=1;
            %graph_matrix(index,feature_vectors(i,j))=1;
            end
        end
        
    end
    
end

%%%Connecting disconnected sets
if 1
graph_matrix(6,7)=1;
graph_matrix(6,2)=1;
graph_matrix(9,11)=1;
graph_matrix(11,1)=1;
graph_matrix(2,18)=0;
graph_matrix(2,17)=0;
graph_matrix(17,2)=1;
graph_matrix(15,5)=1;
graph_matrix(7,12)=1;
graph_matrix(3,4)=0;
graph_matrix(2,10)=0;
graph_matrix(10,2)=1;
graph_matrix(6,9)=0;
graph_matrix(9,6)=1;
graph_matrix(16,12)=1;
graph_matrix(12,16)=0;
graph_matrix(14,16)=0;


end




graph_matrix_digraph=cycle_remove(graph_matrix);
graph_matrix=full(graph_matrix_digraph.adjacency);

%%%To check if meets DAG , max-indegree and max-outdegree conditions.
if_it_meets_problem_conditions(graph_matrix)


%%%To find the CPDs%%%
data_file='train1000.txt';

[parent_array,children_array,cpd_array]=obtain_CPD(data_file,graph_matrix);

prob_vec_original=cpd_array;
par_nodes_original=parent_array;
[s_org,t_org]=adj_matrix_to_list_conv(graph_matrix);


topo_order_nodes=[9 15 11 6 5 1 20 2 7 4 12 3 8 17 18 14 19 10 13 16];
%Topological order of nodes obtained from graph
crude_order_nodes=1:20;
prob_vec={};
par_nodes={};

%%arrange the probabilities in topological order.
for i=1:length(crude_order_nodes)
    %j=find(topo_order_nodes==crude_order_nodes(i))
    j=find(crude_order_nodes==topo_order_nodes(i));
   
    prob_vec{i}=prob_vec_original{j};
    par_nodes{i}=par_nodes_original{j};
end

s=zeros(1,length(s_org));
t=zeros(1,length(t_org));


for i=1:length(s)
    temp1=find(topo_order_nodes==s_org(i));
    s(i)=temp1;
    temp2=find(topo_order_nodes==t_org(i));
    t(i)=temp2;
end

%Evidence_nodes=[1 8 5 14 4];
%evidence_node_values=[0 1 0 1 1]

if 0
%%%%For test50a.txt%%%%
test_file1='test50a.txt';
test_file_read1=tdfread(test_file1);
test_data1=struct2array(test_file_read1);
Evidence_nodes=[6 8 13];
accuracy_vector_a=zeros(1,length(test_data1));
Expected_accuracy_a=zeros(1,length(test_data1));
prediction_matrix_a=zeros(size(test_data1));
feature_wise_accuracy_a=zeros(1,10);
Expected_value_matrix_a=zeros(size(test_data1));
feature_wise_expected_accuracy_a=zeros(1,10);

for i=1:length(test_data1)
%for i=1:4
    
    evidence_node_values=test_data1(i,1:3);%Considering first 3 columns.
    actual_value=test_data1(i,11:20);
    predicted_value=zeros(1,10);
    prob_vector=zeros(1,10);

    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    
    for j=1:10
        k=find(topo_order_nodes==(10+j));
        if(probs(k,1)>0.5)
            predicted_value(j)=0;
            prob_vector(j)=probs(k,1);
        else
            predicted_value(j)=1; 
            prob_vector(j)=probs(k,2);

        end
    end
    
    conf_matrix=confusionmat(actual_value,predicted_value);
    prediction_matrix_a(i,1:10)=test_data1(i,1:10);
    prediction_matrix_a(i,11:20)=predicted_value;
    Expected_value_matrix_a(i,11:20)=prob_vector;
    accuracy=(conf_matrix(1)+conf_matrix(4))/10;
    accuracy_vector_a(i)=accuracy;
    Expected_accuracy_a(i)=mean(prob_vector);
end
average_accuracy_a=mean(accuracy_vector_a);
average_Expected_accuracy_a=mean(Expected_accuracy_a);

dlmwrite('/home/kashyap/Desktop/test50a_predictions.txt',prediction_matrix_a,'delimiter','\t','precision',3);

%%To get feature wise accuracy for a%%

for i=1:10
    conf_matrix_a=confusionmat(test_data1(:,(i+10)),prediction_matrix_a(:,(i+10)));
    feature_wise_accuracy_a(i)=(conf_matrix_a(1)+conf_matrix_a(4))/sum(conf_matrix_a(:));
    feature_wise_expected_accuracy_a(i)=mean(Expected_value_matrix_a(:,i+10));
    
end


%%%%% Test 50a.txt related stuff ends%%%%
end



if 0
%%%%For test50b.txt%%%%
test_file1='test50b.txt';
test_file_read1=tdfread(test_file1);
test_data1=struct2array(test_file_read1); 
Evidence_nodes=[6 8 12 10 5]; %%Mapping from actual columns to their topological counterparts
accuracy_vector_b=zeros(1,length(test_data1));
prediction_matrix_b=zeros(size(test_data1));
Expected_accuracy_b=zeros(1,length(test_data1));
feature_wise_accuracy_b=zeros(1,10);
Expected_value_matrix_b=zeros(size(test_data1));
feature_wise_expected_accuracy_b=zeros(1,10);


for i=1:length(test_data1)
%for i=1:4
    
    evidence_node_values=test_data1(i,1:5); %Considering first 5 columns.
    actual_value=test_data1(i,11:20);
    predicted_value=zeros(1,10);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for j=1:10
        k=find(topo_order_nodes==(10+j));
        if(probs(k,1)>0.5)
            predicted_value(j)=0; 
            prob_vector(j)=probs(k,1);
        else
            predicted_value(j)=1; 
            prob_vector(j)=probs(k,2);
        end
    end
    conf_matrix=confusionmat(actual_value,predicted_value);
    prediction_matrix_b(i,1:10)=test_data1(i,1:10);
    prediction_matrix_b(i,11:20)=predicted_value;
    Expected_value_matrix_b(i,11:20)=prob_vector;
    accuracy=(conf_matrix(1)+conf_matrix(4))/10;
    accuracy_vector_b(i)=accuracy;
    Expected_accuracy_b(i)=mean(prob_vector);
end
average_accuracy_b=mean(accuracy_vector_b);
average_Expected_accuracy_b=mean(Expected_accuracy_b);

dlmwrite('/home/kashyap/Desktop/test50b_predictions.txt',prediction_matrix_b,'delimiter','\t','precision',3);

%%To get feature wise accuracy for b%%

for i=1:10
    conf_matrix_b=confusionmat(test_data1(:,(i+10)),prediction_matrix_b(:,(i+10)));
    feature_wise_accuracy_b(i)=(conf_matrix_b(1)+conf_matrix_b(4))/sum(conf_matrix_b(:));
    feature_wise_expected_accuracy_b(i)=mean(Expected_value_matrix_b(:,i+10));

end


%%%%% Test 50b.txt related stuff ends%%%%
end


if 0
%%%%For test50c.txt%%%%
test_file1='test50c.txt';
test_file_read1=tdfread(test_file1);
test_data1=struct2array(test_file_read1);
Evidence_nodes=[6 8 12 10 5 4 9 ];%%Mapping from actual columns to their topological counterparts
accuracy_vector_c=zeros(1,length(test_data1));
prediction_matrix_c=zeros(size(test_data1));
Expected_accuracy_c=zeros(1,length(test_data1));
feature_wise_accuracy_c=zeros(1,10);
Expected_value_matrix_c=zeros(size(test_data1));
feature_wise_expected_accuracy_c=zeros(1,10);


for i=1:length(test_data1)
%for i=1:4
    
    evidence_node_values=test_data1(i,1:7); %Considering first 7 nodes
    actual_value=test_data1(i,11:20);
    predicted_value=zeros(1,10);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for j=1:10
        k=find(topo_order_nodes==(10+j));
        if(probs(k,1)>0.5)
            predicted_value(j)=0; 
            prob_vector(j)=probs(k,1);
        else
            predicted_value(j)=1; 
            prob_vector(j)=probs(k,2);
        end
    end
    conf_matrix=confusionmat(actual_value,predicted_value);
    prediction_matrix_c(i,1:10)=test_data1(i,1:10);
    prediction_matrix_c(i,11:20)=predicted_value;
    Expected_value_matrix_c(i,11:20)=prob_vector;
    accuracy=(conf_matrix(1)+conf_matrix(4))/10;
    accuracy_vector_c(i)=accuracy;
    Expected_accuracy_c(i)=mean(prob_vector);
end
average_accuracy_c=mean(accuracy_vector_c);
average_Expected_accuracy_c=mean(Expected_accuracy_c);

dlmwrite('/home/kashyap/Desktop/test50c_predictions.txt',prediction_matrix_c,'delimiter','\t','precision',3);

%%To get feature wise accuracy for c%%

for i=1:10
    conf_matrix_c=confusionmat(test_data1(:,(i+10)),prediction_matrix_c(:,(i+10)));
    feature_wise_accuracy_c(i)=(conf_matrix_c(1)+conf_matrix_c(4))/sum(conf_matrix_c(:));
    feature_wise_expected_accuracy_c(i)=mean(Expected_value_matrix_c(:,i+10));
end

%%%%% Test 50c.txt related stuff ends%%%%
end


if 0
%%%%For test50d.txt%%%%
test_file1='test50d.txt';
test_file_read1=tdfread(test_file1);
test_data1=struct2array(test_file_read1);
Evidence_nodes=[6 8 12 10 5 4 9 13 1];%%Mapping from actual columns to their topological counterparts
accuracy_vector_d=zeros(1,length(test_data1));
prediction_matrix_d=zeros(size(test_data1));
Expected_accuracy_d=zeros(1,length(test_data1));
feature_wise_accuracy_d=zeros(1,10);
Expected_value_matrix_d=zeros(size(test_data1));
feature_wise_expected_accuracy_d=zeros(1,10);

for i=1:length(test_data1)
%for i=1:4
    
    evidence_node_values=test_data1(i,1:9); %Considering first 9 columns.
    actual_value=test_data1(i,11:20);
    predicted_value=zeros(1,10);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for j=1:10
        k=find(topo_order_nodes==(10+j));
        if(probs(k,1)>0.5)
            predicted_value(j)=0; 
            prob_vector(j)=probs(k,1);
        else
            predicted_value(j)=1; 
            prob_vector(j)=probs(k,2);
        end
    end
    conf_matrix=confusionmat(actual_value,predicted_value);
    prediction_matrix_d(i,1:10)=test_data1(i,1:10);
    prediction_matrix_d(i,11:20)=predicted_value;
    Expected_value_matrix_d(i,11:20)=prob_vector;
    accuracy=(conf_matrix(1)+conf_matrix(4))/10;
    accuracy_vector_d(i)=accuracy;
    Expected_accuracy_d(i)=mean(prob_vector);
end
average_accuracy_d=mean(accuracy_vector_d);
average_Expected_accuracy_d=mean(Expected_accuracy_d);

dlmwrite('/home/kashyap/Desktop/test50d_predictions.txt',prediction_matrix_d,'delimiter','\t','precision',3);
%%%%% Test 50d.txt related stuff ends%%%%

%%To get feature wise accuracy for d%%

for i=1:10
    conf_matrix_d=confusionmat(test_data1(:,(i+10)),prediction_matrix_d(:,(i+10)));
    feature_wise_accuracy_d(i)=(conf_matrix_d(1)+conf_matrix_d(4))/sum(conf_matrix_d(:));
    feature_wise_expected_accuracy_d(i)=mean(Expected_value_matrix_d(:,i+10));
end

end

%%%%%To fill the Missing Data%%%%
if 1
extra_file='challenge200.txt';
extra_file_read1=tdfread(extra_file);
extra_data1=struct2array(extra_file_read1);

%%%%%First 50 lines with 3 evidence variables%%%%
extra_data_17=extra_data1(1:50,:);
prediction_matrix_17=12*ones(size(extra_data_17));
for i=1:length(extra_data_17)
%for i=11:11    
    prob_vector=zeros(1,20);
    data1=extra_data_17(i,:);
    evidence_nodes_from_data=find(data1~=(-1));
    evidence_node_values=data1(evidence_nodes_from_data);
    Evidence_nodes=zeros(1,length(evidence_nodes_from_data));
    for j=1:length(Evidence_nodes)
        Evidence_nodes(j)=find(topo_order_nodes==evidence_nodes_from_data(j));
    end
    
    num_to_predict=20-length(evidence_nodes_from_data);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for l=1:length(data1)
        k1=find(topo_order_nodes==(l));
        if(probs(l,1)>0.5)
            prob_vector(l)=0; 
        else
            prob_vector(l)=1; 
        end
    end
    for k=1:length(evidence_nodes_from_data)
        prob_vector(evidence_nodes_from_data(k))=evidence_node_values(k);
    end
    prediction_matrix_17(i,:)=prob_vector;
    
end
dlmwrite('/home/kashyap/Desktop/Prediction_with_17_missing_values.txt',prediction_matrix_17,'delimiter','\t','precision',3);


%%%%%Second 50 lines with 5 evidence variables%%%%
extra_data_15=extra_data1(51:100,:);
prediction_matrix_15=12*ones(size(extra_data_15));
for i=1:length(extra_data_15)
%for i=11:11    
    prob_vector=zeros(1,20);
    data1=extra_data_15(i,:);
    evidence_nodes_from_data=find(data1~=(-1));
    evidence_node_values=data1(evidence_nodes_from_data);
    Evidence_nodes=zeros(1,length(evidence_nodes_from_data));
    for j=1:length(Evidence_nodes)
        Evidence_nodes(j)=find(topo_order_nodes==evidence_nodes_from_data(j));
    end
    
    num_to_predict=20-length(evidence_nodes_from_data);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for l=1:length(data1)
        k1=find(topo_order_nodes==(l));
        if(probs(l,1)>0.5)
            prob_vector(l)=0; 
        else
            prob_vector(l)=1; 
        end
    end
    for k=1:length(evidence_nodes_from_data)
        prob_vector(evidence_nodes_from_data(k))=evidence_node_values(k);
    end
    prediction_matrix_15(i,:)=prob_vector;
    
end
dlmwrite('/home/kashyap/Desktop/Prediction_with_15_missing_values.txt',prediction_matrix_15,'delimiter','\t','precision',3);

%%%%%Third 50 lines with 7 evidence variables%%%%
extra_data_13=extra_data1(101:150,:);
prediction_matrix_13=12*ones(size(extra_data_13));
for i=1:length(extra_data_13)
%for i=11:11    
    prob_vector=zeros(1,20);
    data1=extra_data_13(i,:);
    evidence_nodes_from_data=find(data1~=(-1));
    evidence_node_values=data1(evidence_nodes_from_data);
    Evidence_nodes=zeros(1,length(evidence_nodes_from_data));
    for j=1:length(Evidence_nodes)
        Evidence_nodes(j)=find(topo_order_nodes==evidence_nodes_from_data(j));
    end
    
    num_to_predict=20-length(evidence_nodes_from_data);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for l=1:length(data1)
        k1=find(topo_order_nodes==(l));
        if(probs(l,1)>0.5)
            prob_vector(l)=0; 
        else
            prob_vector(l)=1; 
        end
    end
    for k=1:length(evidence_nodes_from_data)
        prob_vector(evidence_nodes_from_data(k))=evidence_node_values(k);
    end
    prediction_matrix_13(i,:)=prob_vector;
    
end
dlmwrite('/home/kashyap/Desktop/Prediction_with_13_missing_values.txt',prediction_matrix_13,'delimiter','\t','precision',3);
%%%%%Fourth 50 lines with 9 evidence variables%%%%
extra_data_11=extra_data1(151:199,:);
prediction_matrix_11=12*ones(size(extra_data_11));
for i=1:length(extra_data_11)
%for i=11:11    
    prob_vector=zeros(1,20);
    data1=extra_data_11(i,:);
    evidence_nodes_from_data=find(data1~=(-1));
    evidence_node_values=data1(evidence_nodes_from_data);
    Evidence_nodes=zeros(1,length(evidence_nodes_from_data));
    for j=1:length(Evidence_nodes)
        Evidence_nodes(j)=find(topo_order_nodes==evidence_nodes_from_data(j));
    end
    
    num_to_predict=20-length(evidence_nodes_from_data);
    probs=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
    for l=1:length(data1)
        k1=find(topo_order_nodes==(l));
        if(probs(l,1)>0.5)
            prob_vector(l)=0; 
        else
            prob_vector(l)=1; 
        end
    end
    for k=1:length(evidence_nodes_from_data)
        prob_vector(evidence_nodes_from_data(k))=evidence_node_values(k);
    end
    prediction_matrix_11(i,:)=prob_vector;
    
end
dlmwrite('/home/kashyap/Desktop/Prediction_with_11_missing_values.txt',prediction_matrix_11,'delimiter','\t','precision',3);

end

%plot(graph_matrix_digraph)







