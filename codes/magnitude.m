v = [1: 2: 20];
v %displays the vector

sv = v.* v;      %the vector with elements as square of v's elements
sv

dp = sum(sv);    % sum of squares -- the dot product
dp

mag = sqrt(dp);  % magnitude
disp('Magnitude:'); disp(mag);
fprintf('Magnitude: %f', mag);