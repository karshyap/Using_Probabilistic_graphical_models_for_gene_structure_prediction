    function[E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,P_e]=update_network(s,t,E,e,V,v_cap,P_e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,topo_order_nodes)
%E-Evidence variable vector. 1 means its observed. -1 means its not
%e-evidence variable value vector. -1 means not observed. 0 or 1 means its
%observed  and they are corresponding values.

E(V)=1; %Updating the variable.
e(V)=v_cap;

for i=1:2
    if((i-1)==v_cap)
        lam_val_array(V,i)=1;
        pi_val_array(V,i)=1;
        P_e(V,i)=1;
    else
        lam_val_array(V,i)=0;
        pi_val_array(V,i)=0;
        P_e(V,i)=0;
    end
    
end

par_V=s(t==V);
child_V=t(s==V);

for i=1:length(par_V)
   % if(~ismember(par_V(i),obsv_var))
    if(E(par_V(i))~=1)
       [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]= send_lam_message(V,par_V(i),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);   
    end
end

for i=1:length(child_V)
       [pi_val_array,lam_val_array,pi_message_array,lam_message_array,prob_vec,P_e]= send_pi_message(V,child_V(i),s,t,E,e,lam_val_array,pi_val_array,lam_message_array,pi_message_array,prob_vec,P_e,topo_order_nodes);
end
end