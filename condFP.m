function [ out_tree ] = condFP( tree,node, currentNode, itemList )
    if isempty(itemList)
        out_tree = tree;
        return;
    else
       idx = findChild(tree, currentNode,itemList(1));
       if idx
           itemList(1) = [];
           out_tree = condFP(tree,node, idx,itemList);
           out_tree(currentNode).count = minSup(out_tree,currentNode);
       else
           newIdx = length(tree)+1;
           tree(newIdx).label = itemList(1);
           tree(newIdx).count = node(itemList(1)).count; 
           tree(newIdx).child = [];
           tree(newIdx).parent = currentNode;
           tree(currentNode).child = [tree(currentNode).child newIdx];      
           itemList(1) = [];
           out_tree = condFP(tree,node,newIdx,itemList);
           out_tree(currentNode).count = minSup(out_tree,currentNode);
       end
              
    end

end
