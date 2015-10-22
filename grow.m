function [ output ] = grow( tree, table, label, min_sup )
        findLink = find(table(:,1) == label);
        firstIdx = table(findLink,3);  %#ok<FNDSB>

        %traverse the linked list of label
        firstNode = tree(firstIdx);
        while firstNode(end).link ~= 0
            firstIdx = [firstIdx ; firstNode(end).link];
            firstNode = [firstNode ; tree(firstNode(end).link)];
        end
        
        %find the matrix of tree
        for i = 1:length(firstIdx)
            currIdx = firstIdx(i);
            currNode = tree(currIdx);
            count = 2;
            while(currNode.parent ~= 1)
                firstIdx(i,count) = currNode.parent;
                count = count+1;
                currNode = tree(currNode.parent);
            end
            nonzero = nnz(firstIdx(i,:));
            lastIdx(i,1:nonzero) = fliplr(firstIdx(i,1:nonzero));
        end
        
        %construct conditional FP-tree
        root(1).label = 0;
        root(1).count = 0;
        root(1).child = [];
        root(1).parent = [];
        
        for i=1:size(lastIdx,1)
            pos = nnz(lastIdx(i,:));
            freqList = lastIdx(i,1:pos);
            %notice that label means the index of node instead of the real
            %value
            root = condFP(root,tree,1,freqList);
        end
        %root(1).label = [];
        %{
        for i=2:length(root)
            root(i).label = tree(root(i).label).label;
            
        change from index of node to label of text
        treeIdx = [];
        for i=1:length(lastIdx)
          pos = nnz(lastIdx(i,:));
          treeIdx(i,1:pos) = [tree(lastIdx(i,1:pos)).label];
        end
        %}
        
        %generate pattern
        pt = [];
        for i = 1:size(lastIdx,1)
            pt = [pt genRule(tree,root,lastIdx(i,:))];
        end
        
        %change from index of node to label of text
        rt=[];
        for i=1:length(pt)
            origin_label = pt(i).label;
            rt(i,1) = pt(i).count;
            for j = 1:length(origin_label)
                mapIdx = tree(origin_label(j));
                rt(i,j+1) = mapIdx.label;
            end
        end
        
        rt = unique(rt,'rows');

        %and eliminate redundancy
        i = 1;
        len = size(rt,1);
        while i<= len
            j = i+1;
            while j<=len
                if all(rt(i,2:end) == rt(j,2:end));
                    rt(i,1) = rt(i,1)+rt(j,1);
                    rt(j,:) = [];
                    len = len-1;
                end
                j = j+1;
            end
            i = i+1;
        end
        
        %filter low
        i = 1;
        ct = 1;
        len = size(rt,1);
        while i<= len
            if(rt(i,1) >= min_sup)
                output(ct,:) = rt(i,:);
                ct = ct+1;
            end
            i = i+1;
        end
            
       %output = rt;
end
