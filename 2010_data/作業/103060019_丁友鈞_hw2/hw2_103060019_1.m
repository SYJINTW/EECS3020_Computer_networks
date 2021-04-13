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