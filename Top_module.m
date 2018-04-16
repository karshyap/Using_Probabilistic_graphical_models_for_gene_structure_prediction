%%%This is the top module which has to be run%%%

function [P_e]=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values)
%clear all;
%clc;clc;


%%So basically we replace A by 1, B by 2, C by 3 ...G by 7 in Figure(1)
%%in question paper.

num_of_nodes=length(prob_vec); %number of nodes in your graph
num_of_vals=2;% number of values for each random variable(node)

g = digraph(s,t); %Directed graph involving s and t.
%labelnode(G,[3 4],'A')
if 0
    plot(g,'o','LineWidth',3,'MarkerSize',5) %To visualise the graph.
    grid()
end 

root_nodes=setdiff(s,t); %%Those which are there only in s and not in t
leaf_nodes=setdiff(t,s);%% Those which are there only in t and not in s



%%%Initialising lamda, pi, values and messages%%%
[lam_val_array,pi_val_array,lam_message_array,pi_message_array,P_e,E,e,prob_vec]=initialise_network(s,t,num_of_nodes,num_of_vals,prob_vec,par_nodes,topo_order_nodes);
%%%Initial Evidence Vector

%%%%%Code running part.. 

%%Add evidence in the way shown%%
%%%Please check P_e for results%%


if 1
for i=1:length(Evidence_nodes)
    V=Evidence_nodes(i);
    v_cap=evidence_node_values(i);
    [E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,P_e]=update_network(s,t,E,e,V,v_cap,P_e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,topo_order_nodes);
end
end

P_e
end
%% Currently  P(D1|B1,G0,F1) is being run. 
% The answer is P_e(4,1)=0.9669 
%(4,1) correspond to fourth element i.e. D having value 1


