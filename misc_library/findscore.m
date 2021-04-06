function [NameIndex,Score] = findscore(varargin)
%{
This function returns a specific score list according to given SubjectName

INPUTS:
- ScoreInfo:    Cell matrix of score information
- SubjectName:  List of subject names for finding score
- Limb:         Type/Header of score to be excerpted

ARGUMENTS:
- NameIndex:    Index of names which are matched
- ListOfScore:	List of scores associated with subject names

%}
    ScoreInfo = varargin{1};
    SubjectName = varargin{2};
    SubjectCol = varargin{3};
    firstRow = varargin{4};
    secondRow = varargin{5};
    thirdRow = varargin{6};
    
    rowParent = 1;  % search category specifying on first row
    colSearch = [];  
    
    %% Locate header in first row, e.g. Limb
    colFirstRow = 1;
    if ~isempty(firstRow)
        colFirstRow = find(strcmp(ScoreInfo(1,:),firstRow));    % Find in 1st row
        if ~isempty(colFirstRow),colSearch = colFirstRow(1); end
    else 
        rowParent = 2;  % search category specifying on second row if first row is empty
    end
    
    %% Locate header in second row, e.g. Test
    colSecondRow = 1;
    if ~isempty(secondRow)
        colSecondRow = find(strcmp(ScoreInfo(2,colFirstRow:end),secondRow));
        if ~isempty(colSecondRow)
            colSecondRow = colSecondRow(1) + colFirstRow - 1;
            rowParent = 2;
            colSearch = colSecondRow(1);
        end
    else 
        if rowParent == 2
            rowParent = 3;  % search category specifying on third row if second row is empty
        end
    end
    
    %% Locate header in third row, e.g. Parity/Others
    if ~isempty(thirdRow)
        stacol = 1;
        if colSecondRow ~= 0, stacol = colSecondRow; end
        colThirdRow = find(strcmp(ScoreInfo(3,stacol:end),thirdRow));
        if ~isempty(colThirdRow)
            colThirdRow = colThirdRow(1) + stacol - 1;
            rowParent = 3;
            colSearch = colThirdRow(1);
        end
    end
    
%     if isempty(colSearch), error('Invaild category name.'); end
    
    %% Get score for subjects
    colSubject = SubjectCol;
    NameIndex = [];
    Score = [];
    if ~isempty(colSearch)
        for i = 1:size(SubjectName,1)
            if size(SubjectName,1) == 1
                i_SI = find(strcmp(ScoreInfo(:,colSubject),SubjectName)); % ScoreInfo index
            else  
                i_SI = find(strcmp(ScoreInfo(:,colSubject),SubjectName(i,1)));  % ScoreInfo index
            end
            if ~isempty(i_SI)
                Score = ScoreInfo{i_SI,colSearch};
                NameIndex = i_SI;
            end
        end
    end
end