function [posOut]=transferFun(pos,temp,ID)

            if ID==1
                s=1/(1+exp(-2*temp)); %S1 transfer function
            end
            if ID==2
                s=1/(1+exp(-temp));   %S2 transfer function              
            end
            if ID==3
                s=1/(1+exp(-temp/2)); %S3 transfer function              
            end
            if ID==4
               s=1/(1+exp(-temp/3));  %S4 transfer function
            end            
                      
            if ID==5
                s=abs(erf(((sqrt(pi)/2)*temp))); %V1 transfer function
            end            
            if ID==6
                s=abs(tanh(temp)); %V2 transfer function
            end            
            if ID==7
                s=abs(temp/sqrt((1+temp^2))); %V3 transfer function
            end            
            if ID==8    %  we use this one  8
                s=abs((2/pi)*atan((pi/2)*temp)); %V4 transfer function     
            end
            
           if ID<=4 %S-shaped transfer functions
                if rand<s % Equation (4) and (8)
                    posOut=1;
                else
                    posOut=0;
                end
           end
            
           if ID>4 && ID<=8 %V-shaped transfer functions
                if rand<s %Equation (10)
                   posOut=~pos; 
                 else
                   posOut=pos;
                end
            end     
            
          
end
      