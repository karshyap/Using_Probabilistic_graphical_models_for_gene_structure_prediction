function[gnew]=cycle_remove(g)
%%To remove cycles in a graph
[s,t]=adj_matrix_to_list_conv(g);
g = digraph(s,t);
e = dfsearch(g, 1, 'edgetodiscovered', 'Restart', true);
gnew = rmedge(g, e(:, 1), e(:, 2));
%gnew = addedge(gnew, e(:, 2), e(:, 1));
end
