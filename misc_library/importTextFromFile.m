function IDName = importTextFromFile(filename, formatSpec, delimiter, startRow, endRow)
%importTextFromFile Import text from a text file as a cell.
%   IDNAME = importTextFromFile(FILENAME,DELIMITER,FORMATSPEC,STARTROW,ENDROW) 
%   Reads data from text file FILENAME separated by DELIMITER with FORMATSPEC
%   from STARTROW to ENDROW (optional).
%
%   DELIMITER = ',' (default)
%   FORMATSPEC = '%s%s%[^\n\r]' (default)
%   STARTROW = 1 (default)
%   ENDROW = Inf (default)
%
% Example:
%   IDName = importfile1('ID_Name.txt', 1, 3);
%

%% Initialize variables.
if nargin<2
    formatSpec = '%s%s%[^\n\r]';
end

if nargin<3
    delimiter = ',';
end

if nargin<=4
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
% For more information, see the TEXTSCAN documentation.
%formatSpec = '%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
IDName = [dataArray{1:end-1}];
end
