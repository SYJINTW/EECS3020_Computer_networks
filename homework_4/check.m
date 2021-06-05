d = load('result.mat').d;
d_ans = load('./ref/result.mat').d;

flag = 0;

for i = 1:n
    for j = 1:n
        if(d(i,j) ~= d_ans(i,j))
            flag = flag+1;
        end
    end
end

fprintf("The ans have %d error.\n", flag);