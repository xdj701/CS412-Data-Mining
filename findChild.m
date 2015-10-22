function [ output ] = findChild( tree, fatherIndex, childName )
    child_list = tree(fatherIndex).child;
    if(isempty(child_list))
        output = 0;
        return;
    end
    for i = 1:length(child_list)
        if tree(child_list(i)).label == childName
            output = child_list(i);
            break
        else
            output = 0;
        end
    end
end
