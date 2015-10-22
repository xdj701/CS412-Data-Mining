function [ sup ] = minSup( tree,currentNode )
        firstNode = tree(currentNode);
        child_num = length(firstNode.child);
        if child_num == 0
            sup = firstNode.count;
            return
        else
            children = [];
            for i = 1:child_num
                children = [children minSup(tree,firstNode.child(i))];
            end
            sup = sum(children);
        end
end

