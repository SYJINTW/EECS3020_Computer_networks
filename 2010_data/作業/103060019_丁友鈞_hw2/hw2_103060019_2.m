load('inputdata')
C=[1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];%CRC-32
Mx=[packet,zeros(1,32)];%multiply input by x^32
R=[];%remainder
for i=1:12000
    if Mx(i)==1%if Mx[i] is 1 , do subtraction ,else do nothing and shift.
        R(1:32)=xor(Mx(i+1:i+32),C(2:33));%the result is remainder during that round.
        Mx(i+1:i+32)=R(1:32);%if the CRC isn't finished,the result of subtraction should be stored to do the next round.
    end
end
codepacket = [packet(1:12000),Mx(12001:12032)];
error=zeros(1,12032);
R1=ones(1,32);
for i=1:12029
    for j=i+1:12030
        for k=j+1:12031
            for l=k+1:12032
               % create four bit change
               error=zeros(1,12032);
               error(i)=1; 
               error(j)=1; 
               error(k)=1; 
               error(l)=1;
               error;
               for x=1:12000
                   if error(x)==1
                       R1(1:32)=xor(error(x+1:x+32),C(2:33));
                       error(x+1:x+32)=R1(1:32);
                   end
               end
               if sum(R1)==0
                   break;
               end
            end
            if sum(R1)==0
                break;
            end
        end
        if sum(R1)==0
            break;
        end
    end
    if sum(R1)==0
        break;
    end
end
error=zeros(1,12032);
error(i)=1;
error(j)=1;
error(k)=1;
error(l)=1;
save('u103060019.mat','codepacket','error');
