function angVel = quaternRate2angVel(q,qr)
% See: 
    angVel = NaN(size(q,1)-1,3);
    for i = 1:size(q,1)-1
        q0 = q(i,1); q1 = q(i,2); q2 = q(i,3); q3 = q(i,4);
        Wq = [-q1  q0  q3 -q2;
              -q2 -q3  q0  q1;
              -q3  q2 -q1  q0];
        angVel(i,:) = 2*Wq*qr(i,:)';
    end

end