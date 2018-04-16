function[lam_val_array,pi_val_array,lam_message_array,pi_message_array,P_e,E,e,prob_vec]=initialise_network(s,t,num_of_nodes,num_of_vals,prob_vec,par_nodes,topo_order_nodes)

root_nodes=setdiff(s,t); %%Those which are there only in s and not in t
leaf_nodes=setdiff(t,s);%% Those which are there only in t and not in s

node_ordering=[3 4 5 6 7 1 2];
node_ordering=graphtopoorder(digraph(s,t).adjacency);




lam_val_array=ones(num_of_nodes,num_of_vals); %%Making all values 1 since initial values are one 
pi_val_array=ones(num_of_nodes,num_of_vals); %However for pi values we are keeping tht as zero as we update it
lam_message_array=-ones(num_of_nodes,num_of_nodes,num_of_vals);%%Making all values 1 since initial values are one 
pi_message_array=-ones(num_of_nodes,num_of_nodes,num_of_vals);%%Making all values 1 since initial values are one 
P_e=ones(num_of_nodes,num_of_vals); %%To store the probabilities
%P_e(1,1)=0.3;
%P_e(1,2)=0.7;
%P_e(2,1)=0.6;
%P_e(2,2)=0.4;

%pi_val_array
P_tilde_x=zeros(num_of_nodes,num_of_vals);

E=-ones(num_of_nodes,1);
e=-ones(num_of_nodes,num_of_vals);

for k =1:num_of_nodes
    i=topo_order_nodes(k);
    %i=k;
    par_node=s(t==i);
    child_node=t(s==i);
    
    for j=1:length(par_node)
        
        lam_message_array(i,par_node(j),:)=1;
    end
    
    for k=1:length(child_node)
 
        pi_message_array(i,child_node(k),:)=1;
    end
    
end
%lam_message_array
%root_nodes;
for i=1:length(root_nodes)
   % i
   % pi_val_array(i)
    %v1=find(node_ordering==root_nodes(i))
    %1-prob_vec{v1}
    %v1=i;
    v1=topo_order_nodes(i)
    v1=i;
    %v1=root_nodes(i);
    pi_val_array(v1,1)=1-prob_vec{v1};
    pi_val_array(v1,2)=prob_vec{v1};
    child_of_i=t(s==root_nodes(v1));
    %'kul'
    for j=1:length(child_of_i)
        %send_pi_message(root_nodes(i),child_of_i(j))
          
         [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_pi_message(root_nodes(i),child_of_i(j),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
    end

end

end
