function[pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_lam_message(y,x,s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes)
%y is the child and x is the parent
temp_var1=1;
temp_var2=1;
prob_vec_temp=prob_vec{y};
par_of_x=s(t==x);

%s
%t
%x
t1=t;
child_of_x=t(s==x);

P_tilde_x=[0 0];
root_nodes=setdiff(s,t); %%Those which are there only in s and not in t
leaf_nodes=setdiff(t,s);%% Those which are there only in t and not in s
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

    if(length(prob_vec_temp)==2) %For a child with single parent
       lam_message_array(y,x,1)=(1-prob_vec_temp(1))*lam_val_array(y,1)+(prob_vec_temp(1))*lam_val_array(y,2); 
       lam_message_array(y,x,2)=(1-prob_vec_temp(2))*lam_val_array(y,1)+(prob_vec_temp(2))*lam_val_array(y,2); 
    end
       

    
    if(length(prob_vec_temp)==4) %For a child with two parents
        par_of_y=s(t==y);
        oth_parents=setdiff(par_of_y,x); %finding other parents of y
        t=oth_parents;
        lam_message_array(y,x,1)=((((1-prob_vec_temp(1))*pi_message_array(y,t,1))+((1-prob_vec_temp(2))*pi_message_array(y,t,2)))*lam_val_array(y,1))  +  ((((prob_vec_temp(1))*pi_message_array(y,t,1))+((prob_vec_temp(2))*pi_message_array(y,t,2)))*lam_val_array(y,2));
        lam_message_array(y,x,2)=((((1-prob_vec_temp(3))*pi_message_array(y,t,1))+((1-prob_vec_temp(4))*pi_message_array(y,t,2)))*lam_val_array(y,1))  +  ((((prob_vec_temp(3))*pi_message_array(y,t,1))+((prob_vec_temp(4))*pi_message_array(y,t,2)))*lam_val_array(y,2));
    end
    
    for i=1:length(child_of_x)
        temp_var1=temp_var1*lam_message_array(topo_order_nodes(child_of_x(i)),x,1);
        temp_var2=temp_var2*lam_message_array(topo_order_nodes(child_of_x(i)),x,2);
    end
    
    lam_val_array(x,1)=temp_var1;
    lam_val_array(x,2)=temp_var2;
    
    P_tilde_x(1)=lam_val_array(x,1)*pi_val_array(x,1);
    P_tilde_x(2)=lam_val_array(x,2)*pi_val_array(x,2);

    
    alpha=P_tilde_x(1)+P_tilde_x(2);
    
    P_e(x,1)=P_tilde_x(1)/alpha;
    P_e(x,2)=P_tilde_x(2)/alpha;
    
    'The required probability is' %#ok<NOPRT>
    P_tilde_x(1)/alpha %#ok<NOPRT>
    'The evidence set is' %#ok<NOPRT>
    E %#ok<NOPRT>
    'The evidence values are' %#ok<NOPRT>
    
    for l=1:length(par_of_x)
        
        if((E(par_of_x(l))~=1) && (~ismember(par_of_x(l),root_nodes)))
            
            %s
            %t
            t=t1;
            [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_lam_message(x,par_of_x(l),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
            
        end
        
    end
    
    otr_children=setdiff(y,child_of_x);
    
    
    for v=1:length(otr_children)
        [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]=send_pi_message(x,otr_children(v),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
    end
    
    
end