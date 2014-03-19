function [x,y] = calc2DPath(data)
%CALC2DPATH Function that calculates a 2D path given delta coordinates for
%the fly
%   Detailed explanatwion goes here

len = length(data{3,1});

forward = .1.*data{1,1};
side = .1.*data{2,1};
yaw = cumsum(data{3,1});

x = zeros(1,len);
y = zeros(1,len);

x(1) = forward(1);
y(1) = side(1);

for i=2:len
    
    x(i) = cos(yaw(i-1))*forward(i);
    y(i) = sin(yaw(i-1))*forward(i);
end

x = cumsum(x);
y = cumsum(y);

end

