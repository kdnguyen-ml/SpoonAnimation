function [axis, angle] = quatern2axisAngle(q)
    angle = 2*acos(q(:,1));
    axis = q(:,2:4)./sqrt(1-q(:,1).^2);
end
