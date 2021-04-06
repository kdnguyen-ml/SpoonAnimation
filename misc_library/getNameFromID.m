function info = getNameFromID(id,C,index)
% Description: Retrive info by its index from matched id in C.
% format as following
% ID,info1,info2
% eg.
% P001,Name1,c/a
% P002,Name2,c/a
%
% Input: 
% - id: a string indicating ID of subject, eg. 'P001' (case sensitive)
% Output:
% - info: information related to subject id.
% _ index: index of information to retrieve
% Example:
% 	getNameFromID('P001',IDname,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    info = 'Undef';
    for i=1:length(C)
        if(strcmp(id,C{i,1}))
            info = C{i,index};
        end
    end
    
end