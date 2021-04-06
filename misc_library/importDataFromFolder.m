function [filename,ID,epoch,marker,rawACC,rawGYR] = importDataFromFolder(folder)
%{
ID follows the naming convention of the clinical protocol
Example: p_01_1_001_1
%}
    filePattern = fullfile(folder,'*.txt');
    filestruct = dir(filePattern);                    %list all text files
    numfiles = length(filestruct);

    filename = cell(numfiles,1);
    ID = cell(numfiles,3);
    epoch = cell(numfiles,1);
    marker = cell(numfiles,1);
    rawACC = cell(numfiles,1);
    rawGYR = cell(numfiles,1);
    
    disp(['Listing all files in folder ' folder ' in order:']);
    for i = 1 : numfiles
        [~,name,~] = fileparts(char({filestruct(i).name})); %show each element of filename 
        disp([num2str(i) '. ' name]);
        
        filename{i,1} = name;
        ID{i,1} = [name(1) name(8:10)];
        ID{i,2} = name(1:10);
        ID{i,3} = [name(6) '-' name(9:10)];
        content = cell2mat(importNumberFromFile([[folder '\'] name '.txt'], '%f%f%f%f%f%f%f%f%[^\n\r]', ','));                %import text file data
        epoch{i,1} = content(:,1);
        marker{i,1} = content(:,2);
        rawACC{i,1} = content(:,3:5);
        rawGYR{i,1} = content(:,6:8);
        clear name content
    end

end