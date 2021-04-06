function featureConcat = concatTrialFeature(feature)
% Join features from different trials for each subject and remove NaN
% Input:
% - feature: n x m - n subjects and m trials (max)
% Output:
% - featureConcat: vector of concated features with NaN removed
featureConcat = reshape(feature',numel(feature),1); 
featureConcat(isnan(featureConcat)) = [];

end