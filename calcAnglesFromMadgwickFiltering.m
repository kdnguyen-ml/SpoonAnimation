function [quat,tilt,euler] = calcAnglesFromMadgwickFiltering(acc,gyr,fs)

    % Madgwick function
    AHRS = MadgwickAHRS('SamplePeriod', 1/fs, 'Beta', 0.4);
    % AHRS = MahonyAHRS('SamplePeriod', 1/fs, 'Kp', 0.5);
    quat = NaN(size(acc,1), 4);
    for i = 1:size(acc,1)
        AHRS.UpdateIMU(gyr(i,:)*(pi/180), acc(i,:)./9.81);	% gyroscope units must be radians
        quat(i, :) = AHRS.Quaternion;
    end
    
    % Angles
    tilt = NaN(size(quat,1),1);
    eulerTemp = quatern2euler(quaternConj(quat)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees. 
    euler{1,1} = eulerTemp(:,1);
    euler{1,2} = eulerTemp(:,2);
%     yaw{itotal,1} = eulerTemp(:,3);
    initVec = [0,1,0]; % assuming initial heading on Y-axis
    pointingVec = quaternRotate(initVec, quat);
    for i = 1:size(acc,1)
        tilt(i,1) = atan2d(pointingVec(i,3),sqrt(pointingVec(i,1)^2 + pointingVec(i,2)^2));
        euler{1,3}(i,1) = sign(pointingVec(i,1))*rad2deg(angleBetween2Vectors([pointingVec(i,1:2),0],initVec));
    end
end