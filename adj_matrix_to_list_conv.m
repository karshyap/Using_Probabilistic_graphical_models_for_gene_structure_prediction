function[s,t]=adj_matrix_to_list_conv(adj_mat)
%%Give a directed graph.
s=zeros(1,sum(sum(adj_mat)));
t=zeros(1,sum(sum(adj_mat)));
[nrow,ncol]=size(adj_mat);
count=0;
for i=1:nrow
    for j=1:ncol
        if(adj_mat(i,j)==1)
            count=count+1;
            s(count)=i;
            t(count)=j;
        end
        
    end
end

     
end
