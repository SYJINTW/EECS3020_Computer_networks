load('network_A.mat'); % 100*100
% load('input_test.mat'); % 10*10
d = A;
n = length(d); % find the max(row,col), but it will be square, so row == col

% using Floyd-Warshall algorithm to find the shortest path
for k = 1:n
    % (i,j) means the path from i to j,
    % and store the min length of path from i to j in d(i,j)
    % then compare with d(i,k)+d(k,j), and store the min length
    % but have to aware '0', because '0' mean infinite in i ~= j
    % so we have to do some check point to check if '0' is exist.
    for i = 1:n 
        for j = 1:n
            % because 0 is mean infinite (means not connected) 
            if(i ~= j) % if i == j then skip
                if((d(i,k) ~= 0) && (d(k,j) ~= 0))
                    if(d(i,j) == 0)
                        d(i,j) = d(i,k)+d(k,j);
                    else
                        d(i,j) = min(d(i,j), d(i,k)+d(k,j));
                    end
                end
            end
        end
    end
end

% save the result d into result.mat
save('result.mat', 'd');

