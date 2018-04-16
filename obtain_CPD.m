function[parent_array,children_array,cpd_array]=obtain_CPD(data_file,graph_matrix)
G=graph_matrix;
%G-> The bayesian graph matrix.
%data_file-> file with training data.

s1 = tdfread(data_file);
training_data=struct2array(s1);

[s,t]=adj_matrix_to_list_conv(G);


parent_array={};
children_array={};

root_nodes=setdiff(s,t); %%Those which are there only in s and not in t
leaf_nodes=setdiff(t,s);%% Those which are there only in t and not in s

for i=1:20
    par_of_i=s(t==i);
    child_of_i=t(s==i);
    
    if(isempty(par_of_i))
        par_of_i=0;
    end
    
     if(isempty(child_of_i))
        child_of_i=0;
     end
    
    parent_array{i}=par_of_i;
    children_array{i}=child_of_i;
    
    
end

cpd_array={};% 
%Main Logic to calculate CPD.

for i=1:20
    par_of_i=parent_array{i};
    par_of_i=par_of_i(par_of_i>0);
    num_of_parents=length(par_of_i);
    
    if(num_of_parents==0)
        cpd_array{i}=sum(training_data(:,i))/length(training_data(:,i));
    end
    
    if(num_of_parents==1)
        temp=training_data;
        temp_array=[0 0];
        
        t0=temp(temp(:,par_of_i)==0,i);
        temp_array(1)=sum(t0)/length(t0);
        
        t1=temp(temp(:,par_of_i)==1,i);
        temp_array(2)=sum(t1)/length(t1);
        
        cpd_array{i}=temp_array;
    end
    
    if(num_of_parents==2)
        par_i=par_of_i;
        temp=training_data;
        temp_array=[0 0 0 0];
        
        t00=temp((temp(:,par_i(1))==0 & temp(:,par_i(2))==0),i);
        temp_aray(1)=sum(t00)/length(t00);
        
        t01=temp((temp(:,par_i(1))==0 & temp(:,par_i(2))==1),i);
        temp_aray(2)=sum(t01)/length(t01);
        
        t10=temp((temp(:,par_i(1))==1 & temp(:,par_i(2))==0),i);
        temp_aray(3)=sum(t10)/length(t10);
        
        t11=temp((temp(:,par_i(1))==1 & temp(:,par_i(2))==1),i);
        temp_aray(4)=sum(t11)/length(t11);
        
        cpd_array{i}=temp_aray;

    end
    
end
end
