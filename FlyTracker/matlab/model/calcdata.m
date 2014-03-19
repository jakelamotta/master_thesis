function [ data,concatdata ] = calcdata(output)
%Function that calculates the data for for the raw mouse input. output and
%output_time has very specific restrictions on them, see help manual for
%this. Returns data divided into blocks and the fully concatenated data
%cell. The latter is used for plotting and is not saved.
%*******************************************************
%Precondition:
%Input format
%Blocks separated by "*"
%*******************************************************

% blocks = parseInput(output);
% size_ = size(blocks);

% for k=1:1
%     %output = blocks{1,k};
%     starts = strfind(output,'{');
%     ends = strfind(output,'}');
%     len = length(starts);
% 
%     %dynamic values later
%     alpha_ = .0185;
%     omega = 0;%pi/4;
%     r = 25;
% 
%     side = zeros(1,len);
%     forward = zeros(1,len);
%     yaw = zeros(1,len);
%     times = zeros(1,len);
% 
%     data = cell(4,1);
% 
% 
%     for i=1:len
%         temp = JSON.parse(output(starts(i):ends(i)));
%         x1 = temp.x_1;
%         x2 = temp.x_2;
%         y1 = temp.y_1;
%         y2 = temp.y_2;
%         time = temp.t;
% 
%         w_m = alpha_.*[cos(omega),-sin(omega);sin(omega),cos(omega)]*[y1;y2];
% 
%         w_mz = alpha_*(x1+x2)/(2*r);
% 
%         side(i) = w_m(1);
%         forward(i) = w_m(2);
%         yaw(i) = w_mz;%*180/pi;    
%         times(i) = time;
%     end
%     
% end
%     data{1,k} = side;
%     data{2,k} = forward;
%     data{3,k} = yaw;
%     data{4,k} = times;
%     concatdata = data;
%     
%     concatdata = concatBlocks(data);

starts = strfind(output,'{');
ends = strfind(output,'}');
len = length(starts);

%dynamic values later
alpha_ = .0175;
omega = 0;%pi/4;
r = 25;

side = zeros(1,len);
forward = zeros(1,len);
yaw = zeros(1,len);
times = zeros(1,len);

data = cell(4,1);


for i=1:len
    temp = JSON.parse(output(starts(i):ends(i)));
    x1 = temp.x_1;
    x2 = temp.x_2;
    y1 = temp.y_1;
    y2 = temp.y_2;
    time = temp.t;

    w_m = alpha_.*[cos(omega),-sin(omega);sin(omega),cos(omega)]*[y1;y2];

    w_mz = alpha_*(x1*.1+x2*.1)/(2*r);

    side(i) = w_m(1);
    forward(i) = w_m(2);
    yaw(i) = w_mz;%*180/pi;    
    times(i) = time;
end
    data{1,1} = side;
    data{2,1} = forward;
    data{3,1} = yaw;
    data{4,1} = times;
    concatdata = data;
    
end

%Function that concatenate all blocks in one data cell for each variable
%respectively and the resulting cell will be a 4x1 cell. If the input is
%already of this dimension the input is returned.
function [concatdata] = concatBlocks(data)

   len = size(data);
      
   %len(2) is number of blocks, if only one concatenating is not needed
   if len(2) > 1
       concatdata = cell(4,1);

       for i=1:len(2)
           if length(data{1,i}) ~= 0
               concatdata{1,1} = [concatdata{1,1},data{1,i}];
               concatdata{2,1} = [concatdata{2,1},data{2,i}];
               concatdata{3,1} = [concatdata{3,1},data{3,i}];
               concatdata{4,1} = [concatdata{4,1},data{4,i}];
           end           
       end
   else
       %Data is consisiting of one block only
       concatdata = data;
   end

end

function [ array_of_blocks ] = parseInput(filedata)
%parseInput is a function for separating blocks of raw data from each other
%return an array of strings, each containing data for one block

    %filedata = transpose(filedata);
    numBlocks = strfind(filedata,'*');
    len = length(numBlocks);
    
    if len > 0
        array_of_blocks = cell(1,len);
    
        array_of_blocks(1) = filedata(1:numBlocks(1)-1);
    
        for i=2:len-1
            array_of_blocks(i) = filedata(numBlocks(i-1)+1:numBlocks(i)-1);
        end
    else
        array_of_blocks = {filedata};
    end
    
end