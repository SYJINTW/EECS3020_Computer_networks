load('network_A.mat')
X=zeros(2,100); % X(1, *) store the distance, X(2, *) store the last connected node
% cause 1 is root, so check if the node is directly connect to the root
for i=1:100
    if(A(1,i)==1)
        X(1,i)=1;
        X(2,i)=1;
    end
end
% find the distance 1 above and find the distance 2 to the Max
for distance=2:100
    for j=1:100
        if(X(1,j)==distance-1)
            for k=1:100
               if(A(j,k)==1 && X(2,k)==0) % if there is a connection and also no smaller distance (0 means no path yet)
                   X(1,k)=distance; % store the distance
                   X(2,k)=j; % store the last node
               end
            end
        end
    end
end
tree=zeros(100,100); % for the answer matrix
for i=1:100
    tree(i,X(2,i))=1;
    tree(X(2,i),i)=1;
end

% save the result tree into result.mat
save('result.mat', 'tree');
