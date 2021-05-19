load('result.mat')
A = tree;
load('result_1.mat')
B = tree;
for i=1:100
    for j=1:100
       if(A(i,j) ~= B(i,j))
           fprintf('(%d, %d) -> wrong\n', i, j);
           break;
       end
    end
end

fprintf('Correct\n');