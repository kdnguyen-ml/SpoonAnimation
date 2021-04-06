function [compx,compe] = datalosscompensation(x, epoch, fs)
%{
    - Count number of data loss in a frame (defined by 2 consecutive existing
    epoches)
    - Compensate using moving average
    - Append the lost data at the end of a frame
    epoch in 0.1s, each frame has fse = fs/10 data points
    Example: [new_compensated_data,newepoch] = datalosscompensation(imu_total_rawACC{1,1}(:,1),imu_total_epoch{1,1},50);
%}
    N = size(x,1);  % number of samples
    fse = fs/10;    % sample per epoch
    depoch = NaN(N,1);
    depoch(1) = 1;  % different in epoch: [1,0,...,1,0,0,0,0,1...]
    depoch(2:N) = epoch(2:N) - epoch(1:N-1);
    e = find(depoch > 0);   % index when change of epoch occurs
    e(end+1) = N;  % last data
    compx = [];
    compe = [];
    for i = 1:length(e)-2   % exclude last frame and last data
        xdata = x(e(i):e(i+1)-1,:);
        edata = epoch(e(i):e(i+1)-1);
        de = e(i+1) - e(i);         % number of data points between 2 consecutive epoches
        total_loss = fse*depoch(e(i+1)) - de;
        if total_loss == 0      % full frame without loss or duplication
            compx = [compx; xdata];
            compe = [compe; edata];
        elseif total_loss > 0           % total loss of data points = loss within the frame (i) + frame (i+x) loss * frame data
            compx = [compx; xdata];
            compe = [compe; edata];
            eloss = fse - de;       % loss within the frame
            xbin = (x(e(i+1),:) - x(e(i+1)-1,:)) ./ (total_loss + 1);
            for j = 1:total_loss
                compx = [compx; x(e(i+1)-1,:)+j*xbin];
%                 floor((j - eloss - 1)/fse);
                if floor((j - eloss - 1)/fse) < 0
                    compe = [compe; epoch(e(i))];
                else
                    compe = [compe; epoch(e(i)) + floor((j - eloss - 1)/fse) + 1];
                end
            end 
            clear xbin
        elseif total_loss < 0   % duplication of data
            xdata(randi([1,de]),:) = [];
            compx = [compx; xdata];
            compe = [compe; edata(1:5)];
        end
        
    end
    % Add last frame based on the data
    compx = [compx; x(e(end-1):e(end),:)];
    compe = [compe; epoch(e(end-1):e(end),:)];
end