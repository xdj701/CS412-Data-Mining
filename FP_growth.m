clc;
clear;
close all;
%remember call modifyTXT.m to modify text for adding one to each element
modifyTXT(0);
readFile = 'modify-0.txt';
writeFile = 'pattern-0.txt';
% find descending frequent items L 
D = dlmread(readFile);
map = containers.Map('KeyType','int32','ValueType','int32');
[row,col] = size(D);
for i = 1:row
    for j = 1:col
        if D(i,j) == 0
            break;
        else
            if(isKey(map,D(i,j)) == 0)
                map(D(i,j)) = 1;
            else
                map(D(i,j)) = map(D(i,j))+1;
            end
        end
    end
end

F = transpose(cell2mat([keys(map);values(map)]));
L = sortrows(F,-2);
%set minimum support and confidence
min_sup = floor(0.01*row);
%rearrange elements in every row by descending occurence
sort_D = zeros(size(D));
for i = 1:row
    pos = nnz(D(i,:));
    tran = zeros(col,2);
    for j = 1:pos
        if map(D(i,j)) >= min_sup
            tran(j,:) = [D(i,j);map(D(i,j))];
        end
    end
    sort_tran = sortrows(tran,-2);
    sort_D(i,:) = sort_tran(:,1);
end
%remove all zero columns and rows
sort_D(:,all(sort_D==0,1))=[];
sort_D(all(sort_D==0,2),:)=[];
[new_row, new_col] = size(sort_D);
%record tree
T = zeros(new_row+1,2);
%record child
Child = zeros(new_row+1,new_row);
%Header Table(L3 as link)
L =  L(L(:,2)>=min_sup,:);
L(:,3) = 0;

template.label = -1;
template.count = 0;
template.child = [];
template.parent = [];
template.link = 0;

%build FP-tree
node(1) = template;
for i = 1:new_row
    poz = nnz(sort_D(i,:));
    freqList = sort_D(i,1:poz);
    [node,L] = insert(node,L,1,freqList);
end
      
%mine the tree
freqRule = [];
count = 1;
for i = 1:length(L)
    tmp = grow(node,L,L(length(L)-i+1,1),min_sup);
    [tmp_row tmp_col] = size(tmp);
    for ii = 1:tmp_row
        freqRule(count,1:tmp_col) = tmp(ii,:);
        count = count+1;
    end            
end

%sort the matrix and map back to text
sort_Rule = sortrows(freqRule,-1);
vocab = readtable('vocab.txt','Delimiter','tab','ReadVariableNames',false);
vocab = table2cell(vocab);
rule_row = size(sort_Rule,1);
convert_Rule = cell(rule_row,2);
for i = 1:rule_row
    convert_Rule(i,1) = {sort_Rule(i,1)};
    nonzero = nnz(sort_Rule(i,:));
    nameStr = [];
    for j = 2:nonzero
        nameStr = [nameStr, ' ', cell2mat(vocab(sort_Rule(i,j),2))];
    end
    convert_Rule(i,2) = {nameStr};
end


%write to file
fileID = fopen(writeFile,'w');
for i = 1:size(convert_Rule,1)
    support = cell2mat(convert_Rule(i,1));
    pattern = cell2mat(convert_Rule(i,2));
    pattern(1) =[];
    fprintf(fileID,'[%d] [%s]\n',support,pattern);
end
fclose(fileID);
