function h = plot_raw_waveform_marker(acc,gyr,markerSeries)
%{
Plot raw waveform of accelerometer, gyroscope and marker as a function of samples
and save to folder '..\Figure\Waveform'
%}

h = figure;
marker = find(markerSeries);

% Accelerometer plot
numSamples = size(acc,1);
if isempty(marker) && marker(1) == 0, marker(1) = 1; end
if isempty(marker) && marker(2) == 0, marker(2) = numSamples; end
time = 1:numSamples;
%     time = (0:1:numSamples-1) / imu_freq(total,1);
subplot1 = subplot(2,1,1); hold on;
plot(time,acc(:,1),'b','LineWidth',1);
plot(time,acc(:,2),'g','LineWidth',1);
plot(time,acc(:,3),'r','LineWidth',1);
% Marker plot
if ~isempty(marker)
    for i = 1:length(marker)
        line([marker(i) marker(i)],get(gca,'YLim'),'Color','k','LineWidth',2)
    end
end
legend('Ax','Ay','Az','Location','NorthEastOutside');
    axP = get(subplot1, 'Position');
    set(subplot1, 'Position', axP);
xlabel('Samples');
ylabel('Accelerometer (g)')
axis([0 numSamples min(min(acc)) max(max(acc))]);
%     axis([0 (numSamples-1)/imu_freq(total,1) min(min(series)) max(max(series))]);
title('Raw Waveform')
set(gca,'FontSize',15)

% Gyroscope plot
subplot2 = subplot(2,1,2); hold on; 
plot(time,gyr(:,1),'b','LineWidth',1);
plot(time,gyr(:,2),'g','LineWidth',1);
plot(time,gyr(:,3),'r','LineWidth',1);
% Marker plot
if ~isempty(marker)
    for i = 1:length(marker)
        line([marker(i) marker(i)],get(gca,'YLim'),'Color','k','LineWidth',2)
    end
end
legend('Gx','Gy','Gz','Location','NorthEastOutside');
    axP = get(subplot2, 'Position');
    set(subplot2, 'Position', axP);
xlabel('Samples');
ylabel('Gyroscope (deg/s)')
axis([0 numSamples min(min(gyr)) max(max(gyr))]);
%     axis([0 (numSamples-1)/imu_freq(total,1) min(min(series)) max(max(series))]);
set(gca,'FontSize',15)
clear axP subplot1 subplot2 series numSamples marker
    
end