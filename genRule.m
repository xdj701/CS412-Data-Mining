function [ pattern ] = genRule( tree,cond_tree, path )
    nonzero = nnz(path);
    leafIdx = path(nonzero);    
    leafNode = cond_tree(find([cond_tree.label] == leafIdx));
    labels(1).label = leafNode.label;
    %labels(1).label = tree(leafNode.label).label;
    labels(1).count = leafNode.count;
    len = 2;
    if nnz(path) == 1
        labels(1).count = cond_tree(1).count;
        pattern = labels;
        return
    else
        for i=1:power(2,nonzero-1)-1
            store = nonzero-1;
            shift = i;
            labels(len).label = labels(1).label;
            labels(len).count = labels(1).count;
            while(shift~=0)
                if(mod(shift,2) == 1)
                    newNode = cond_tree(find([cond_tree.label] == path(store)));
                    labels(len).label = [ newNode.label labels(len).label];
                    %labels(len).label = [labels(len).label tree(newNode.label).label];
                end
                %labels(len).count = ;
                shift = floor(shift/2);
                store = store-1;
            end
            if length(labels(len).label) <= 2
                labels(len).count = cond_tree(find([cond_tree.label] ==  labels(len).label(1)  )).count;
            else
                labels(len).count = cond_tree(find([cond_tree.label] ==  labels(len).label(end)  )).count;
            end
            len = len+1;
        end
        
        for k=1:length(labels)
            if length(labels(k).label) == 1
                labels(k).count = cond_tree(1).count;
            end
        end
   
        pattern = labels;
    end
            
end

