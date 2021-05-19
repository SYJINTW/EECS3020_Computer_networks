load('network_A.mat')
tree = zeros(100,100); %answer matrix
distance = zeros(1, 100); %the distance from root to the vertexs
update = zeros(1,100); %the neighbor of the vertex we are calculating
updatetmp = zeros(1,100);%the neighbor's neighbor
connect = zeros(1,1000); %where vertex connect to(to root)
found = zeros(1,100); %already found its neighbor to the root
upnum = 1; %how many updating now
upnumtmp = upnum; %incase not to change the updatenum in the same floor

for i = 1:100
    connect(1:i) = -1; %At first, we don't know where we connect to 
end

%the first "for" loop calculate the root's neighbor vertex
for i=1:100 
    if (A(1,i) == 1) %if the vertex and the root is connected
        found(1,i) = A(1,i);
        tree(1,i) = 1;
        tree(i,1) = 1;
        distance(1,i) = 1; 
        connect(1,i) = 1;
        update(1,upnum) = i;
        upnum = upnum + 1;
    end
end

%when no vertex to update or every vertex except root is connect to root
%finish the "while" loop
while (upnum ~= 1 || sum(found) ~= 99)
    upnumtmp = upnum;
    upnum = 1;
    
    for i=1:(upnumtmp - 1) %check all the next level of the pre level
        for j=2:100 %check except the root
            if(A(update(1,i),j) == 1)
                
                %if the vertex is not used yet
                if(distance(1,j)==0)
                    distance(1,j) = distance(1,update(1,i))+1;
                    found(1,j)=1;
                    connect(1,j) = update(1,i);
                    
                    %put the connection in the tree
                    tree(update(1,i),j)=1;
                    tree(j,update(1,i))=1;
                    %change the updatetmp for the next floor
                    updatetmp(1,upnum)=j;
                    upnum = upnum + 1;
                    
                %if we find a shorter path between the vertices
                elseif(distance(1,j) > distance(1,update(1,i)) + 1)
                    distance(1,j) = distance(1,update(1,i))+1;
                    found(1,j)=1;
                    connect(1,j) = target(1,i);
                    tree(update(1,i),j)=1;
                    tree(j,update(1,i))=1;

                    %cancel the connection for the pre connnection
                    tree(connect(1,j),j)=0;
                    tree(j,connect(1,j))=0;
                    %change the updatetmp for the next floor
                    updatetmp(1,upnum)=j;
                    upnum = upnum + 1;
                    
                %if the distance is same, we want the smaller index    
                elseif(distance(1,j) == distance(1,update(1,i))+1)
                    if(connect(1,j) > update(1,i)) 
                        found(1,j)=1;
                        
                        %change the variable in the tree
                        %cancel the conncetion of the pre connection
                        tree(connect(1,j),j)=0;
                        tree(j,connect(1,j))=0;
                        tree(update(1,i),j)=1;
                        tree(j,update(1,i))=1;
                        
                        %change the connect of j
                        connect(1,j) = update(1,i);
                        
                        %change the updatetmp for the next floor
                        updatetmp(1,upnum)=j;
                        upnum = upnum + 1; 
                    end
                end
                
            end
        end
    end
    
    %reset the target for the next floor
    for i=1:100
        update(1,i) = updatetmp(1,i);
        updatetmp(1,i) = 0;
    end
end

%take the result in tree into result.mat
save('result.mat', 'tree');