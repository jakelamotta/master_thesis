function [ data,concatdata ] = calcdata(output)
%Function that calculates the data for for the raw mouse input. output and
%output_time has very specific restrictions on them, see help manual for
%this. Returns data divided into blocks and the fully concatenated data
%cell. The latter is used for plotting and is not saved.
%*******************************************************
%Precondition:
%Input format
%Blocks separated by "pause"
%*******************************************************

config = getappdata(0,'config');

starts = strfind(output,'{');
ends = strfind(output,'}');
len = length(starts);

%dynamic values later
alpha_ = config.alpha_*-1;
beta_ = config.beta_*-1;
omega = config.theta_;
r = config.radius/2; %mm

side = zeros(1,len);
forward = zeros(1,len);
yaw = zeros(1,len);
times = zeros(1,len);

data = cell(4,1);


for i=1:len
    temp = JSON.parse(output(starts(i):ends(i)));
    x1 = temp.x_1-1;
    x2 = temp.x_2;
    y1 = temp.y_1;
    y2 = temp.y_2;
    time = temp.t;

    w_m = beta_.*[cos(omega),-sin(omega);sin(omega),cos(omega)]*[y1;y2];

    t = (x1+x2)/2;
    
    if sign(x1) == -1 && sign(x2) == -1
        t = max(x1,x2);
    elseif sign(x1)*sign(x2) == -1
        if sign(x1) == -1
            if abs(x1)<x2
                if abs(x1)<t
                    t = x1;
                end
            else
                if x2<abs(t)
                    t = x2;
                end
            end
        elseif sign(x2) == -1
            if abs(x2)<x1
                if abs(x2)<t
                    t = x2;
                end
            else
                if x1<abs(t)
                    t = x1;
                end
            end
        end
    elseif sign(x1) == 1 && sign(x2) == 1
        t = min(x1,x2);
    end 
        
    w_mz = alpha_*t/(r);
    
    side(i) = w_m(1);
    forward(i) = w_m(2);
    
    %%Scaling down small values
%     if abs(w_mz)*180/pi < 1.5 %((abs(x1)+abs(x2))/2)-((abs(y1)+abs(y2))/2) < 10
%         w_mz = w_mz*.2;        
%     end
    
    yaw(i) = w_mz;    
    times(i) = .1*time;
end
    data{2,1} = side;
    data{1,1} = forward;
    data{3,1} = yaw;
    data{4,1} = times;
    concatdata = data;    
end

% %Function that concatenate all blocks in one data cell for each variable
% %respectively and the resulting cell will be a 4x1 cell. If the input is
% %already of this dimension the input is returned.
% function [concatdata] = concatBlocks(data)
% 
%    len = size(data);
%       
%    %len(2) is number of blocks, if only one concatenating is not needed
%    if len(2) > 1
%        concatdata = cell(4,1);
% 
%        for i=1:len(2)
%            if length(data{1,i}) ~= 0
%                concatdata{1,1} = [concatdata{1,1},data{1,i}];
%                concatdata{2,1} = [concatdata{2,1},data{2,i}];
%                concatdata{3,1} = [concatdata{3,1},data{3,i}];
%                concatdata{4,1} = [concatdata{4,1},data{4,i}];
%            end           
%        end
%    else
%        %Data is consisiting of one block only
%        concatdata = data;
%    end
% 
% end
% 
% 
% 
% function [ array_of_blocks ] = parseInput(filedata)
% %parseInput is a function for separating blocks of raw data from each other
% %return an array of strings, each containing data for one block
% 
%     %filedata = transpose(filedata);
%     numBlocks = strfind(filedata,'*');
%     len = length(numBlocks);
%     
%     if len > 0
%         array_of_blocks = cell(1,len);
%     
%         array_of_blocks(1) = filedata(1:numBlocks(1)-1);
%     
%         for i=2:len-1
%             array_of_blocks(i) = filedata(numBlocks(i-1)+1:numBlocks(i)-1);
%         end
%     else
%         array_of_blocks = {filedata};
%     end
%     
% end