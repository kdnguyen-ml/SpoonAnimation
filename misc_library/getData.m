function [nSub,ID,sensorData] = getData(path_data)

% path_data = '..\Data\Patient';
% path_data = '..\Data\Control';

% Get data from sensor file
% Control
% Transfer text files to mat files
fprintf('Getting IMU data from %s: ',path_data);
filePattern = fullfile(path_data,'*.txt');
fileStruct = dir(filePattern);                    %list all text files
nSub = length(fileStruct);

ID = cell(nSub,8);
sensorData = cell(nSub,1);
for i = 1 : nSub
    [~,name,~] = fileparts(char({fileStruct(i).name})); %show each element of filename
    ID(i,:) = [name; split(name,'_')]';
%     ID{i,1} = name(1:14);             % full file name
%     ID{i,2} = [name(1) name(10:12)];  % c001
%     ID{i,3} = name(2:3);              % clinician ID
%     ID{i,4} = name(5:6);              % test ID
%     ID{i,5} = name(8);                % subtest
%     ID{i,6} = name(14);               % trial
%     ID{i,7} = name(end);              % sensor ID
    content = cell2mat(importNumberFromFile([[path_data '\'] name '.txt'], '%f%f%f%f%f%f%f%f%[^\n\r]', ','));                %import text file data
    sensorData{i,1} = content(:,1:8);
    clear name content
end

fprintf('%d subjects.\n',nSub);
end