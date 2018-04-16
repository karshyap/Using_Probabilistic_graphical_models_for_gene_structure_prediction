clear all;
s=[1 2 3 3 4 4];%Graph structure in matlab. s and t are arrays where s[i]->t[i]
t=[3 3 4 5 6 7];
topo_order_nodes=1:7;


prob_vec={0.7,0.4,[0.1,0.5,0.3,0.9],[0.8,0.3],[0.2,0.6],[0.1,0.7],[0.9,0.4]}; %writing initial probabilities
%prob_vec={0.7,0.4,[0.1,0.5,0.3,0.9],[0.2,0.6],[0.8,0.3],[0.1,0.7],[0.9,0.4]}; %writing initial probabilities
par_nodes={0,0,[1,2],3,3,4,4};%If parent node is zero that means given node is root node

if 0
%s=[ 3 2 4 1 3 4];%Graph structure in matlab. s and t are arrays where s[i]->t[i]
%t=[ 4 3 7 3 5 6];    
    
prob_vec_original={[0.2,0.6],[0.1,0.7],0.7,[0.9,0.4],[0.8,0.3],0.4,[0.1,0.5,0.3,0.9]}; %writing initial probabilities
par_nodes_original={3,4,0,4,3,0,[1,2]};%If parent node is zero that means given node is root node

topo_order_nodes=graphtopoorder(digraph(s,t).adjacency);
crude_order_nodes=[ 4 6 1 7 5 2 3];
topo_order_nodes=[1 2 3 5 4 6 7];
%topo_order_nodes=1:7;
prob_vec={};
par_nodes={};

for i=1:length(crude_order_nodes)
    %j=find(topo_order_nodes==crude_order_nodes(i))
    j=find(crude_order_nodes==topo_order_nodes(i));

    prob_vec{i}=prob_vec_original{j};
    par_nodes{i}=par_nodes_original{j};
end
end

prob_vec
par_nodes

Evidence_nodes=[ 7 12 1 2 3 4];
evidence_node_values=[  1 1 0 1 0 1  ];
%t1=Top_module(s,t,prob_vec,par_nodes,topo_order_nodes,Evidence_nodes,evidence_node_values);
%plot(digraph(s,t))