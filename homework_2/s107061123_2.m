% find correct codepacket
A = load('inputdata.mat','-mat');
inputdata = A.packet;
p = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1]; % CRC-32 polynomial C(x)

data = [inputdata, zeros(1,32)]; % inputdata + 32 of zero in the back
remainder = zeros(1,33); % for store the answer after XOR
for i=1:length(inputdata)
    if data(i) == 1 % if cal_data[i] is 1 , do XOR, else do nothing and shift.
        remainder(1:33) = xor(data(i:i+32),p(1:33)); % the result is remainder during that round.
        data(i:i+32) = remainder(1:33); % if the CRC isn't finished, the result of XOR should be stored to do the next round.
    end
end
check = data(12001:12032);
codepacket = [inputdata, data(12001:12032)];

% find error
errorMatrix = [];
for i=1:12032
    error = codepacket;
    error(i) = xor(error(i),1);
    
    remainder = zeros(1,33);
    for j=1:length(inputdata)
        if error(j) == 1
            remainder(1:33) = xor(error(j:j+32),p(1:33));
            error(j:j+32) = remainder(1:33);
        end
    end
    check = error(12001:12032);
    errorMatrix = [errorMatrix; check];
end

%save('e107061123.mat','errorMatrix');

% if input 'e107061123.mat' then have to use the two lines below
% errorMatrix = load('e107061123.mat','-mat');
% errorMatrix = errorMatrix.errorMatrix;

z = zeros(1,32);
find = [];
for i=1:12029
    for j=i+1:12030
        for k=j+1:12031
            for l=k+1:12032
                flag = 0;
                if xor(xor(errorMatrix(i,:),errorMatrix(j,:)),xor(errorMatrix(k,:),errorMatrix(l,:))) == z
                    flag = 1;
                    fprintf("find %d %d %d %d\n", i, j, k, l);
                    find = [i, j, k, l];
                end
            end
            if flag
                break;
            end
        end
        if flag
                break;
        end
    end
    if flag
        break;
    end
end

error=zeros(1,12032);
error(find(1))=1;
error(find(2))=1;
error(find(3))=1;
error(find(4))=1;

save('s107061123.mat','codepacket','error');


