function qLog = quaternLog(q)

[axis, angle] = quatern2axisAngle(q);
qLog = [zeros(size(q,1),1),angle./2.*axis];

end