function dataArray = importInfoFromFileName(varargin)

formatSpec = '%s%d%d%s%s%d%d';
delimiter = '_';
roe = false; eol = '\r\n';
tfv = false;
filename = varargin{1};
for i = 2:2:nargin
    if  strcmp(varargin{i}, 'FormatSpec'), formatSpec = varargin{i+1};
    elseif  strcmp(varargin{i}, 'Delimiter'), delimiter = varargin{i+1};
    elseif  strcmp(varargin{i}, 'ReturnOnError'), roe = varargin{i+1};
    elseif  strcmp(varargin{i}, 'EndOfLine'), eol = varargin{i+1};
    elseif  strcmp(varargin{i}, 'ToFormattedVariable'), tfv = varargin{i+1};
    else, error('Invalid argument.');
    end
end

if ~tfv
    dataArray = textscan(filename,formatSpec,'Delimiter',delimiter,'ReturnOnError',roe,'EndOfLine',eol);
else
    dataArrayTemp = textscan(filename,formatSpec,'Delimiter',delimiter,'ReturnOnError',roe,'EndOfLine',eol);
    dataArray{1,1} = filename;  % full file name
    dataArray{1,2} = dataArrayTemp{1,1}{1}(1); % c/p
    dataArray{1,3} = dataArrayTemp{1,1}{1}(2:end); % clinician
    dataArray{1,4} = dataArrayTemp{1,2}; % test ID
    dataArray{1,5} = dataArrayTemp{1,3}; % subtest ID
    dataArray{1,6} = dataArrayTemp{1,4}{1}; % c/p ID
    dataArray{1,7} = dataArrayTemp{1,5}{1}; % test-retest
    dataArray{1,8} = dataArrayTemp{1,6}; % epoch
    dataArray{1,9} = dataArrayTemp{1,7}; % sensor ID
    
    datetime(dataArrayTemp{1,6},'Convertfrom','posixtime','TimeZone','Australia/Sydney');  % date
    
end

end