function [s_numfiles,score_info] = importscore(ScoreFileName,sheetnum)
%{
This function reads xlsx file that contains score information, and save to
a cell matrix

INPUTS:
- ScoreFileName:    Xlsx file of scores
- sheetnum:         Sheet number

ARGUMENTS:
- s_numfiles:       Number of subject in given score table
- score_info:        Cell matrix of given score table
%}
    disp('Reading xlsx file...');
    filename = ScoreFileName;   % 'score.xlsx';
    [score_num,~,score_info] = xlsread(filename,sheetnum);   % read number as score_num and text&num as score_info
        
    % Find first column number and data start row --> scan by column
    flag = 0;
    for j = 1:size(score_info,2)
        if flag == 1, break; end
        for i = 1:size(score_info,1)
            if ~isnan(score_info{i,j}(1)) && isnumeric(score_info{i,j})
                firstColNum = j;
                dataStartRow = i;
                flag = 1;
                break;
            end
        end
    end
    
    % Find first column number and data start row --> scan by column
    flag = 0;
    for i = 1:size(score_info,2)
        if flag == 1, break; end
        for j = 1:size(score_info,1)
            if ~isnan(score_info{i,j}(1)) && isnumeric(score_info{i,j})
                firstRowNum = i;
                flag = 1;
                break;
            end
        end
    end
    
    s_numfiles = size(score_info(dataStartRow:end,1),1);   % Discard Upper/Lower Limb header, test header, column header
    s_numheaders = size(score_info,2);
    
    % Convert number column in score_info to number
    disp('Convert number column to number');
    t_header = 1:firstColNum-1;   % NaN columns = text header
    for i = 1:size(score_num,2)
        if sum(isnan(score_num(dataStartRow-firstRowNum+1:end,i))) > s_numfiles/2    % text more than 50%
            t_header = [t_header i+firstColNum-1];
        end
    end
%     disp('Converting number cell to number, NaN is converted to -1...');
%     score_num(ismissing(score_num)) = -1;  % NaN = -1
    
    n_header = 1:size(score_num,2)+firstColNum-1;    % number column
    n_header(t_header) = [];   
    for j = n_header
        for i = dataStartRow:dataStartRow+s_numfiles-1
            score_info{i,j} = score_num(i-(firstRowNum-1),j-(firstColNum-1));   % 2 header rows in score_num (-1 row)
        end
    end
end