clc, clear

% Add library
addpath('quaternion_library','misc_library');

% Constant
FS = 100;
step = 6;
View = [-140,22];  %[-122,9]
CreateAVI = false;
AVIfileNameEnum = true;
AVIfps = 30;

% Retrieve variables
[filename,ID,epoch,marker,rawACC,rawGYR] = importDataFromFolder('.\Data');

%% Choose a file to plot
disp('Plotting file at index: 1'); index = 1;
% index = input('Plotting file at index: ');
disp(['Filename: "' filename{index,1} '"'])
duration = epoch{index,1}(end)-epoch{index,1}(1)+1;
freq = length(epoch{index,1})*10/duration; % sampling freq from data should be close to FS
fprintf('Duration: %.1f\n',duration/10)
fprintf('Sampling frequency from data: %.4f\n',freq)

% plot_raw_waveform_marker(rawACC{1},rawGYR{1},marker{1})

%% Set video parameters
AVIfileName = ['trajectory-' num2str(index)];

aviobj = [];                                                            	% create null object
if(CreateAVI)
    fileName = strcat(AVIfileName, '.avi');
    if(exist(fileName, 'file'))
        if(AVIfileNameEnum)                                              	% if file name exists and enum enabled
            i = 0;
            while(exist(fileName, 'file'))                                  % find un-used file name by appending enum
                fileName = strcat(AVIfileName, sprintf('%i', i), '.avi');
                i = i + 1;
            end
        else, fileName = [];                                                  % file will not be created
        end
    end
    if(isempty(fileName)), sprintf('AVI file not created as file already exists.')
    else, aviobj = VideoWriter(fileName, 'Motion JPEG AVI'); open(aviobj);
%	aviobj = avifile(fileName, 'fps', AVIfps, 'compression', 'Cinepak', 'quality', 100);
    end
end

%% Initialise figure
fig = figure('NumberTitle', 'off', 'Name', '6DOF Animation');
set(gcf, 'Units', 'Normalized', 'Position', [0 0.0556 1 0.8435]);
scale = 0.1;
P = []; P(1,:)=[0,-1,0];
PX(1,:) = P(1,:)+[1*scale,0,0];
PY(1,:) = P(1,:)+[0,1*scale,0];
PZ(1,:) = P(1,:)+[0,0,1*scale];

scaleSpoon = makehgtform('scale',0.006);
trans = makehgtform('translate',-0.5,-0.25,-0.1);
rotx = makehgtform('xrotate',pi/2); roty = makehgtform('yrotate',pi/2); rotz = makehgtform('zrotate',pi/180*-5);

% Calculate angles
acc = rawACC{index};
gyr = rawGYR{index};
[quat,tilt,euler] = calcAnglesFromMadgwickFiltering(acc,gyr,FS);

% Segmentation
segment = find(marker{index});
% seg1 = segment(1):segment(2); seg2 = segment(3):segment(4); seg3 = segment(5):segment(6); % first 3
seg1 = segment(end-5):segment(end-4); seg2 = segment(end-3):segment(end-2); seg3 = segment(end-1):segment(end); % last 3
allseg = [seg1,seg2,seg3];
numSamples = length(allseg);
MeasTime = (0:numSamples-1)/FS;

% ACC subplot
subplot1Dacc = subplot(3,2,2); hold on;
axis([0 (numSamples-1)/FS min(min(acc))-0.001 max(max(acc)+0.001)]);
accHandleX = plot(subplot1Dacc,allseg(1),acc(allseg(1),1),'b');
accHandleY = plot(subplot1Dacc,allseg(1),acc(allseg(1),2),'g');
accHandleZ = plot(subplot1Dacc,allseg(1),acc(allseg(1),3),'r');
legend(subplot1Dacc, 'X', 'Y', 'Z', 'Location', 'northeast', 'color', 'none');
ylabel('Accelerometer (g)');
grid on;

% GYR subplot
subplot1Dgyr = subplot(3,2,4); hold on;
axis([0 (numSamples-1)/FS min(min(gyr))-0.001 max(max(gyr)+0.001)]);
gyrHandleX = plot(subplot1Dgyr,allseg(1),gyr(allseg(1),1),'b');
gyrHandleY = plot(subplot1Dgyr,allseg(1),gyr(allseg(1),2),'g');
gyrHandleZ = plot(subplot1Dgyr,allseg(1),gyr(allseg(1),3),'r');
legend(subplot1Dgyr, 'X', 'Y', 'Z', 'Location', 'northeast', 'color', 'none');
ylabel('Gyroscope (deg/s)');
grid on;

% Tilt subplot 
series1D = tilt;
subplot1Dtilt = subplot(3,2,6); hold on
plot(MeasTime(1:length(seg1)),series1D(seg1),'k');
plot(MeasTime(1+length(seg1):length([seg1,seg2])),series1D(seg2),'b');
plot(MeasTime(1+length([seg1,seg2]):length([seg1,seg2,seg3])),series1D(seg3),'r');
track_line = line(subplot1Dtilt,[0,0],get(gca,'YLim'),'Color','k','LineWidth',1);
track_point = scatter(subplot1Dtilt,0,series1D(allseg(1)),20,'r','filled');
legend(subplot1Dtilt, 'Trial 1', 'Trial 2', 'Trial 3', 'Location', 'northeast', 'color', 'none');
xlabel('Time (s)');
ylabel('Tilt (deg)')
axis tight
grid on;

% Spoon subplot
subplot3D = subplot(3,2,[1,3,5]); hold on; grid on;   
scatter3(0,0,0,10,'r','filled');  % Center dot
text(0.05,0,0,'[0,0,0]')
title(filename{index});

% 3D Sphere
[xcylinder,ycylinder,zcylinder] = cylinder([0.2 0.2]);
[xsphere,ysphere,zsphere] = sphere();
surf(xsphere,ysphere,zsphere,'FaceAlpha',0.1,'EdgeColor','k','EdgeAlpha',0.05,'LineStyle','-','FaceColor','none')
hold on

% Generate 3D object and handle
spoonObj = stlread('spoonPart1.stl');
h = patch(spoonObj,'FaceColor', [0.8 0.8 1.0], 'EdgeColor', 'none',...
         'FaceLighting', 'gouraud', 'AmbientStrength', 0.15);
camlight('left'); material('dull');
axis([-1 1, -2.2 1, -1 1])

spoonHandle = hgtransform('parent', subplot3D);
set(h, 'parent', spoonHandle, 'FaceLighting','phong');
set(spoonHandle,'matrix',scaleSpoon);
R = quatern2rotMat(quat(allseg(1),:))'; 
P(2,:) = (R*P(1,:)')';
set(spoonHandle,'matrix',[R(1,1:3,1) 0; R(2,1:3,1) 0; R(3,1:3,1) 0; 0 0 0 1]*rotx*roty*rotz*trans*scaleSpoon);
quivhandle = quiver3(subplot3D, 0, 0, 0, P(2,1), P(2,2), P(2,3), 1, 'r', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.5, 'AutoScale', 'off');
view(View(1),View(2))
xlabel('X'),ylabel('Y'),zlabel('Z')

%% Main loop
iMap = 50;
for ii=2:step:length(allseg)        
    if ii > length(allseg), continue; end
    set(track_line, 'xdata', [MeasTime(ii),MeasTime(ii)], 'ydata', get(subplot1Dtilt,'YLim')); hold on
    set(track_point, 'xdata', MeasTime(ii), 'ydata', series1D(allseg(ii),1));
    titleText = sprintf('Sample %i of %i', ii, length(allseg));
    title(subplot1Dacc, titleText);
    
    % Plot Acceleration
    set(accHandleX, 'xdata', MeasTime(1:ii), 'ydata', acc(1:ii,1));
    set(accHandleY, 'xdata', MeasTime(1:ii), 'ydata', acc(1:ii,2));
    set(accHandleZ, 'xdata', MeasTime(1:ii), 'ydata', acc(1:ii,3));
    
    % Plot Rotational rate
    set(gyrHandleX, 'xdata', MeasTime(1:ii), 'ydata', gyr(1:ii,1));
    set(gyrHandleY, 'xdata', MeasTime(1:ii), 'ydata', gyr(1:ii,2));
    set(gyrHandleZ, 'xdata', MeasTime(1:ii), 'ydata', gyr(1:ii,3));
    
    R = quatern2rotMat(quat(allseg(ii),:))';	% Compute the associated transformation marix
    P(ii,:) = (R*P(1,:)')';
    PX(ii,:) = (R*PX(1,:)')';
    PY(ii,:) = (R*PY(1,:)')';
    PZ(ii,:) = (R*PZ(1,:)')';
    set(spoonHandle,'matrix',[R(1,1:3,1) 0; R(2,1:3,1) 0; R(3,1:3,1) 0; 0 0 0 1]*rotx*roty*rotz*trans*scaleSpoon);
    set(quivhandle, 'xdata', 0, 'ydata', 0, 'zdata', 0, 'udata', P(ii,1), 'vdata', P(ii,2), 'wdata', P(ii,3));
    
    % Display the new heading point
    if ii <= length(seg1), pcolor = 'k';
    elseif length(seg1) < ii && ii <= length([seg1,seg2]), pcolor = 'b';
    else, pcolor = 'r';
    end
    scatter3(subplot3D,P(ii,1),P(ii,2),P(ii,3),5,pcolor,'filled');
    
    hold on;
    drawnow;
    
    % Add frame to AVI object
    if(~isempty(aviobj))
        frame = getframe(fig);
        writeVideo(aviobj,frame);
%       aviobj = addframe(aviobj, frame);
    end
    
end

hold off;

% Close AVI file
if(~isempty(aviobj))
    close;
end
