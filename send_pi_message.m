function[pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_pi_message(z,x,s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes)
%z is parent and  x is its child
child_of_z=t(s==z);
lam_message_array;
otr_children=setdiff(child_of_z,x);
temp_val1=1;
temp_val2=1;
P_tilde_x=[0 0];
par_of_x=s(t==x);
child_of_x=t(s==x);
par_temp_of_x=zeros(length(par_of_x),1);
child_temp_x=zeros(length(child_of_x),1);

if 0
for i =1:length(par_of_x)
    par_temp_of_x(i)=find(topo_order_nodes==par_of_x(i));
end

for i=1:length(child_of_x)
    child_temp_x(i)=find(topo_order_nodes==child_of_x(i));
end

par_of_x=par_temp_of_x;
child_of_x=child_temp_x;
end
z
x
otr_children;
root_nodes=setdiff(s,t); %%Those which are there only in s and not in t
leaf_nodes=setdiff(t,s);%% Those which are there only in t and not in s
%x=find(topo_order_nodes==x);
%z=find(topo_order_nodes==z);

if(length(otr_children)>0)
 for i=1:length(otr_children)
    %temp_val1=temp_val1*lam_message_array(otr_children(i),z,1);
    %temp_val2=temp_val2*lam_message_array(otr_children(i),z,2);
    temp_val1=temp_val1*lam_val_array(topo_order_nodes(otr_children(i)),1);
    temp_val2=temp_val2*lam_val_array(topo_order_nodes(otr_children(i)),2);

 end
end

pi_message_array(x,z,1)=pi_val_array(z,1)*temp_val1;
pi_message_array(x,z,2)=pi_val_array(z,2)*temp_val2;

%pi_message_array(z,x,1)=pi_val_array(z,1)*temp_val1;
%pi_message_array(z,x,2)=pi_val_array(z,2)*temp_val2;



prob_vec_temp=prob_vec{x};
par_of_x;
x;
prob=prob_vec_temp;

if(E(x)~=1)
    if(length(prob_vec_temp)==2) %For a child with single parent
        pi_val_array(x,1)= (1-prob_vec_temp(1))*pi_message_array(x,z,1)+(1-prob_vec_temp(2))*pi_message_array(x,z,2);
        pi_val_array(x,2)= (prob_vec_temp(1))*pi_message_array(x,z,1)+(prob_vec_temp(2))*pi_message_array(x,z,2);
        %pi_val_array(x,1)= (1-prob_vec_temp(1))*pi_message_array(z,x,1)+(1-prob_vec_temp(2))*pi_message_array(z,x,2)
       % pi_val_array(x,2)= (prob_vec_temp(1))*pi_message_array(z,x,1)+(prob_vec_temp(2))*pi_message_array(z,x,2);

    end
    if(length(prob_vec_temp)==4) %For a child with two parents
       % prob_vec
       % par_of_x
       % x
        %pi_message_array(x,7,1)
       %(pi_message_array(x,par_of_x(2),1))
        pi_val_array(x,1)=((1-prob(1))*(pi_message_array(x,par_of_x(1),1))*(pi_message_array(x,par_of_x(2),1)))  +  ((1-prob(2))*(pi_message_array(x,par_of_x(1),1))*(pi_message_array(x,par_of_x(2),2)))  +  ((1-prob(3))*(pi_message_array(x,par_of_x(1),2))*(pi_message_array(x,par_of_x(2),1)))   +  ((1-prob(4))*(pi_message_array(x,par_of_x(1),2))*(pi_message_array(x,par_of_x(2),2)));  
        pi_val_array(x,2)=((prob(1))*(pi_message_array(x,par_of_x(1),1))*(pi_message_array(x,par_of_x(2),1)))  +  ((prob(2))*(pi_message_array(x,par_of_x(1),1))*(pi_message_array(x,par_of_x(2),2)))  +  ((prob(3))*(pi_message_array(x,par_of_x(1),2))*(pi_message_array(x,par_of_x(2),1)))   +  ((prob(4))*(pi_message_array(x,par_of_x(1),2))*(pi_message_array(x,par_of_x(2),2)));  
        %pi_val_array(x,1)=((1-prob(1))*(pi_message_array(par_of_x(1),x,1))*(pi_message_array(par_of_x(2),x,1)))  +  ((1-prob(2))*(pi_message_array(par_of_x(1),x,1))*(pi_message_array(par_of_x(2),x,2)))  +  ((1-prob(3))*(pi_message_array(par_of_x(1),x,2))*(pi_message_array(par_of_x(2),x,1)))   +  ((1-prob(4))*(pi_message_array(par_of_x(1),x,2))*(pi_message_array(par_of_x(2),x,2)));  
        %pi_val_array(x,2)=((prob(1))*(pi_message_array(par_of_x(1),x,1))*(pi_message_array(par_of_x(2),x,1)))  +  ((prob(2))*(pi_message_array(par_of_x(1),x,1))*(pi_message_array(par_of_x(2),x,2)))  +  ((prob(3))*(pi_message_array(par_of_x(1),x,2))*(pi_message_array(par_of_x(2),x,1)))   +  ((prob(4))*(pi_message_array(par_of_x(1),x,2))*(pi_message_array(par_of_x(2),x,2)));  

    end
    
        P_tilde_x(1)=lam_val_array(x,1)*pi_val_array(x,1);
        P_tilde_x(2)=lam_val_array(x,2)*pi_val_array(x,2);

    %transpose(pi_val_array)
    %pi_message_array
    alpha=P_tilde_x(1)+P_tilde_x(2);
    if 0
    'The variables z and x are' %#ok<NOPRT>
    z,x %#ok<NOPRT>
    'The required probability is' %#ok<NOPRT>
    P_tilde_x(2)/alpha %#ok<NOPRT>
    %'The evidence set is' %#ok<NOPRT>
    %E %#ok<NOPRT>
    %'The evidence values are' %#ok<NOPRT>
    %e
    end
    %P_e
    P_e(x,1)=P_tilde_x(1)/alpha;
    P_e(x,2)=P_tilde_x(2)/alpha;
    for i=1:length(child_of_x)
        if(~ismember(x,leaf_nodes))
            [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_pi_message(x,child_of_x(i),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
        end
        
    end
end
    
    w=setdiff(par_of_x,z);
   % lam_val_array
   % x
    if((lam_val_array(x,1)~=1)||(lam_val_array(x,2)~=1))
        for k=1:length(w)
            if(~ismember(w(k),E))
                [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_lam_message(x,w(k),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
            end
            
        end
        
    end
    




end
