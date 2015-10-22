function [out_tree, out_table ] = insert( tree,table, currentNode, itemList )
    if isempty(itemList)
        out_tree = tree;
        out_table = table;
        return;
    else
       idx = findChild(tree,currentNode,itemList(1));
       if idx
           tree(idx).count = tree(idx).count+1;
           itemList(1) = [];
           [out_tree,out_table] = insert(tree,table,idx,itemList);
       else
           newIdx = length(tree)+1;
           tree(newIdx).label = itemList(1);
           tree(newIdx).count = 1;
           tree(newIdx).child = [];
           tree(newIdx).parent = currentNode;
           tree(newIdx).link = 0;   
           tree(currentNode).child = [tree(currentNode).child newIdx];
           
           findLink = find(table(:,1) == itemList(1));
           if table(findLink,3) == 0
               table(findLink,3) = newIdx;
           else
               firstIdx = table(findLink,3);
               firstNode = tree(firstIdx);
               while firstNode.link ~= 0
                   firstIdx = firstNode.link;
                   firstNode = tree(firstIdx);
               end
               tree(firstIdx).link = newIdx;
           end             
           
           itemList(1) = [];
           [out_tree,out_table] = insert(tree,table,newIdx,itemList);
       end
              
    end

end

