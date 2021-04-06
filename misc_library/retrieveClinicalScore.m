function cScore = retrieveClinicalScore(varargin)
% retrieveClinicalScore(subject,{'NineHPTR'}): mean Left and Right
% retrieveClinicalScore(subject,{'NineHPTR'},'Exact',true): only Right

subjectTable = varargin{1};
ScoreType = varargin{2};
isExact = false;
isDominance = true;
for i = 3:2:nargin
    if strcmp(varargin{i},'Exact'), isExact = varargin{i+1};
    elseif strcmp(varargin{i},'Dominance'), isDominance = varargin{i+1};
    else, error('Invalid argument.');
    end
end

TableColumn = subjectTable.Properties.VariableNames;
cScore = NaN(size(subjectTable,1),length(ScoreType));
for iType = 1:length(ScoreType)  % run through Score types
    iTableColumn = find(startsWith(TableColumn,ScoreType{iType}));
%     fprintf('%d. %s -- \n',iType,TableColumn{iTableColumn});
    if length(iTableColumn) == 1
        if ~isExact && (strcmp(TableColumn{iTableColumn},'NineHPTR') || strcmp(TableColumn{iTableColumn},'BnBR')) % 9HPT, BBT
            subCell = subjectTable{:,iTableColumn}; iNaN = find(cellfun('isempty',subCell));
            subCell(iNaN) = num2cell(NaN(length(iNaN),1));
            value1 = cell2mat(subCell); iVal = find(value1 >= 777); value1(iVal) = NaN(length(iVal),1);
            subCell = subjectTable{:,iTableColumn+1}; iNaN = find(cellfun('isempty',subCell));
            subCell(iNaN) = num2cell(NaN(length(iNaN),1));
            value2 = cell2mat(subCell); iVal = find(value2 >= 777); value2(iVal) = NaN(length(iVal),1);
            iVal = find(isnan(value1)); value1(iVal) = value2(iVal);
            iVal = find(isnan(value2)); value2(iVal) = value1(iVal);
            cScore(:,iType) = mean([value1,value2],2);
        else
            subCell = subjectTable{:,iTableColumn}; iNaN = find(cellfun('isempty',subCell));
            subCell(iNaN) = num2cell(NaN(length(iNaN),1));
            value1 = cell2mat(subCell); 
%             iVal = find(value1 >= 777); value1(iVal) = NaN(length(iVal),1);
            cScore(:,iType) = value1;
        end
    else
        rightCol = iTableColumn(endsWith(TableColumn(iTableColumn),'R'));
        leftCol = iTableColumn(endsWith(TableColumn(iTableColumn),'L'));
        dominance = subjectTable{:,8}; 
        iR = strcmp(dominance,'R'); iL = strcmp(dominance,'L');
        if isDominance == false, iR = ~iR; iL = ~iL; end
        
        subCell = subjectTable{:,rightCol}; iNaN = find(cellfun('isempty',subCell));
        subCell(iNaN) = num2cell(NaN(length(iNaN),1));
        value1 = cell2mat(subCell); 
        if ~isExact,iVal = find(value1 >= 777); value1(iVal) = NaN(length(iVal),1); end
        cScore(iR,iType) = value1(iR);
        
        subCell = subjectTable{:,leftCol}; iNaN = find(cellfun('isempty',subCell));
        subCell(iNaN) = num2cell(NaN(length(iNaN),1));
        value1 = cell2mat(subCell); 
        if ~isExact,iVal = find(value1 >= 777); value1(iVal) = NaN(length(iVal),1); end
        cScore(iL,iType) = value1(iL);
    end
end
end