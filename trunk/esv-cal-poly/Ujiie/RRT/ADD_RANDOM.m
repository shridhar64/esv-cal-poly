function TEMP_NODE= ADD_RANDOM(NODE_DIST, TREE, NODES, RAND_SPACE)

%SETS A RANDOM NODE
RAND_NODE(1)=RAND_SPACE(1,1)*rand+RAND_SPACE(2,1);    %X
RAND_NODE(2)=RAND_SPACE(1,2)*rand+RAND_SPACE(2,2);    %Y 
        
%SOLVING FOR THE DISTANCE TO THE RANDOM NODE
%INITIALIZES RAND_DIST TO A MAXIMUM VALUE WHICH WOULD BE 
%THE DISTANCE TO THE START OF THE TREE
RAND_DIST=((RAND_NODE(1)-TREE(1,1))^2+(RAND_NODE(2)-TREE(1,2))^2)^.5; 
        
%DETERMINING CLOSEST NODE TO THE RANDOM NODE
for i=1:1:NODES
    
    %SOLVING FOR THE DISTANCE TO THE RANDOM NODE FROM THE A NODE IN [TREE]
    TEMP_DIST=((RAND_NODE(1)-TREE(i,1))^2+(RAND_NODE(2)-TREE(i,2))^2)^.5;
    
    if (TEMP_DIST<=RAND_DIST)
        RAND_DIST=TEMP_DIST;               %MAKES THE CHECKED DISTANCE THE NEW DISTANCE
        CLOSE_NODE=TREE(i, 1:2);           %SETS THE CLOSEST NODE
        TEMP_NODE(3)=i;                    %MARKS WHAT NODE IT IS
    end
    
end
        
%LOCATION OF TEMPORARY NODE
TEMP_NODE(1)=CLOSE_NODE(1) + NODE_DIST*(RAND_NODE(1)-CLOSE_NODE(1))/RAND_DIST;   %X
TEMP_NODE(2)=CLOSE_NODE(2) + NODE_DIST*(RAND_NODE(2)-CLOSE_NODE(2))/RAND_DIST;   %Y
                
if (TEMP_NODE(2)<CLOSE_NODE(2))
    TEMP_NODE(3)=TREE(TEMP_NODE(3),3);
end


end