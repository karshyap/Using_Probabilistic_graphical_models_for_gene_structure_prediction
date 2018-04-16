function[]=if_it_meets_problem_conditions(G)
G_dig=digraph(G);
flag=0;
%Checking if the matrix is directed acyclic.
if(~isdag(G_dig))
    flag=1;
end
max_indegree=max(indegree(G_dig));
max_outdegree=max(outdegree(G_dig));

%checking if the indegree and outdegree are greater than 2
if(max_indegree>2 || max_outdegree>2)
    flag=1;
end
if(max_indegree>2)
    'Nodes having indegree>2 are'
    find(indegree(G_dig)>2)
end

if(max_outdegree>2)
    'Nodes having outdegree>2 are'
    find(outdegree(G_dig)>2)
end

if(~flag)
    'The graph is meeting all conditions'
end

