Instructions for running the Code:

1. Please run Top_module.m
2. Place all the files in same folder
3. Please change the values of V and v_cap for testing for different conditions.
   Please make corresponding 'if' statements zero or 1 

In the code submitted c P(D1|B1,G0,F1) is being run. 
The answer is P_e(4,1)=0.9669 
(4,1) correspond to fourth element i.e. D having value 1 in probability array

For example you want to run P(G1|C0) then make the bottom two if statements 0 
and then V=3 and V_cap=1 (so as to signify C0). This gives a P(G1|C0)=0.5

If only two evidence variables are observed then only last if is made 0 and so on. 
