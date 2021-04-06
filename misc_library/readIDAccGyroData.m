function [epoch, marker, AccGyroData, numfiles, f_name, name_list] = readIDAccGyroData(folderpath,filefolder)
%% LR = 1: right hand, LR = 2: left hand, LR = 0 ( 0 means not patients, don t have status)
    epoch = {}; marker = {}; AccGyroData = {}; f_name = {}; name_list = {};
	filepath = [folderpath filefolder];
	files = dir(filepath);
	numfiles = length(files)-2;

	for m = 3:numfiles+2
        filename = char(files(m).name);
        f = fullfile(filepath,filename);
        mydata = dlmread(f);
        epoch{m-2} = mydata(:,1);
        marker{m-2} = mydata(:,2);
        AccGyroData{m-2} = mydata(:,3:8);
            
        [pathstr,name,ext] = fileparts(f);
        f_name{m-2} = name(1:12);
        token = regexp(name,'\_','split');
        id = [token{1,1} token{1,4}];
        name_list{m-2} = getNameFromID(id);
    end 
end


function name = getNameFromID(id)
% Description: Get name from ID by mapping into text file (ID_Name.txt),
% format as following
% ID;Name
% eg.
% P001;Name1
% P002;Name2
%
% Input: 
% - id: a string indicating ID of subject, eg. 'P001' (case sensitive)
% Output:
% - name: a string indicating name of subject.
% Example:
% getNameFromID('P001');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    name = 'Undef';
     
    filename = 'ID_Name.txt';
    fileID = fopen(filename,'r');
     
    C = textscan(fileID,'%s %s','Delimiter',',');

    for i=1:length(C{1,1})
        if(strcmp(id,C{1,1}(i)))
            name = C{1,2}(i);
            break;
        end
    end
%     fclose(fileID);
    
end