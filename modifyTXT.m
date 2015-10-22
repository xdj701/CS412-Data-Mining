function [ output ] = modifyTXT( input )
    switch input
        case 0
            readFile = 'topic-0.txt';
            writeFile = 'modify-0.txt';
        case 1
            readFile = 'topic-1.txt';
            writeFile = 'modify-1.txt';
        case 2
            readFile = 'topic-2.txt';
            writeFile = 'modify-2.txt';   
        case 3
            readFile = 'topic-3.txt';
            writeFile = 'modify-3.txt';
        case 4
            readFile = 'topic-4.txt';
            writeFile = 'modify-4.txt'; 
        otherwise
            disp('no such file')
    end
    fileIDR = fopen(readFile,'r');
    fileIDW = fopen(writeFile,'w');
    tline = fgetl(fileIDR);
    while ischar(tline)
        str = str2num(tline);
        str = str+1;
        nline = num2str(str,'%d ');
        fprintf(fileIDW,'%s\n',nline);
        tline = fgetl(fileIDR);
    end

    fclose(fileIDR);
    fclose(fileIDW);

end
