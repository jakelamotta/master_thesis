function [x,y] = calc2DPath(data,block)
%CALC2DPATH Function that calculates a 2D path given delta coordinates for
%the fly
%   Detailed explanatwion goes here

len = length(data{3,block});

forward = data{1,block};
side = data{2,block};
yaw = cumsum(data{3,block});

x = zeros(1,len);
y = zeros(1,len);

x(1) = forward(1);
y(1) = side(1);

for i=2:len
    
    x(i) = x(i-1)+cos(yaw(i-1))*side(i)-forward(i)*sin(yaw(i-1));
    y(i) = y(i-1)+sin(yaw(i-1))*side(i)+forward(i)*cos(yaw(i-1));
end

%x = cumsum(x);
%y = cumsum(y);

end

