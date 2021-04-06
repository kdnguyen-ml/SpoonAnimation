function angle = angleBetween2Vectors(a,b)
% or angle = atan2(norm(cross(a,b)), dot(a,b))
% W. Kahan suggested in his paper "Mindeless.pdf":
% angle = 2 * atan(norm(a*norm(b) - norm(a)*b) / norm(a * norm(b) + norm(a) * b));
    angle = 2 * atan(norm(a*norm(b) - norm(a)*b) / norm(a * norm(b) + norm(a) * b));

end