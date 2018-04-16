g=graph_matrix_digraph;
h = plot(g,'NodeLabel',[]);
for i=1:20
text(h.XData(i)+0.1,h.YData(i),num2str(i),'fontsize',22);
end