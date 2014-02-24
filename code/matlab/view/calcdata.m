function [ data,concatdata ] = calcdata(output,output_time)
%Function that calculates the data for for the raw mouse input. output and
%output_time has very specific restrictions on them. See developers guide
%for this. 
    
    %Call local function parseInput
    [datablocks,timeblocks] = parseInput(output,output_time);
    
    result = cell(1,length(datablocks));
    data = cell(4,length(datablocks));
    
    for k=1:length(datablocks)
        
        temp = [0];

        try        
            curr = datablocks(k);
            block = curr{1};
            for i=1:(length(block)/7)-1
                if i == 1
                    str_ = strcat(block(2),block(3),block(4),block(5),block(6));
                    temp(1) = str2num(str_);
                    a = 9;
                end
                str_ = strcat(block(a),block(a+1),block(a+2),block(a+3),block(a+4));
                temp(end+1) = str2num(str_);
                a = a+7;
            end
        catch Exception
            %output
            errordlg('Something went wrong with the data, please try again', 'Corrupt data');        
        end
        
        result{1,k} = temp;
        
        [forward,side,yaw] = convertData(result{1,k});
        
        data{1,k} = forward;
        data{2,k} = side;
        data{3,k} = yaw;
        
        time = [];
    
        try        
            curr = timeblocks(k);
            block = curr{1};

            for i=1:(length(block)/8)-1
                if i == 1
                    str_ = strcat(block(2),block(3),block(4),block(5),block(6),block(7));
                    time(i) = str2num(str_);
                    a = 10;
                end

                str_ = strcat(block(a),block(a+1),block(a+2),block(a+3),block(a+4),block(a+5));
                time(i) = str2num(str_);
                a = a+8;
            end
        catch Exception
            errordlg('Something went wrong with the timestamps, please try again', 'Corrupt data');        
        end    
        
        time(end+1) = 0;
        data{4,k} = time;
        concatdata = concatBlocks(data);
    end
    
    
    
    
    
%         length(result)
%         length(time)
        
%         try        
%             for i=1:(length(output)/6)-1
%                 if i == 1
%                     result(1) = str2num(output(1:5));
%                     a = 6;
%                 end
% 
%                 time(end+1) = i+1;
%                 result(end+1) = str2num(output(a:a+5));
%                 a = a+6;
%             end
%         catch Exception
%             output
%             errordlg('Something went wrong with the data, please try again', 'Corrupt data');        
%         end     


end

%Function that concatenate all blocks in one data cell for each variable
%respectively and the resulting cell will be a 4x1 cell. If the input is
%already of this dimension the input is returned.
function [fullsequence] = concatBlocks(data)

   len = size(data);
   
   if len > 1
       fullsequence = cell(4,1);
   
       fullsequence{1,1} = [data{1,1}];
       fullsequence{1,2} = [data{2,1}];
       fullsequence{1,3} = [data{3,1}];
       fullsequence{1,4} = [data{4,1}];


       for i=2:len(2)
           fullsequence{1,1} = [fullsequence{1,1},data{1,i}];
           fullsequence{2,1} = [fullsequence{2,1},data{2,i}];
           fullsequence{3,1} = [fullsequence{3,1},data{3,i}];
           fullsequence{4,1} = [fullsequence{4,1},data{4,i}];
       end
   else
       fullsequence = data;
   end

end

%Function that do the actual calculation of fly movement by transforming
%the mouse input data to fly's forward,sideway and yaw delta coords
function [forward,side,yaw] = convertData(data)

    %Calibration data, hardcoded for testing purposes will be changed to
    %dynamic values later
    alpha_ = 1;
    omega = -45;
    r = .04;

    %Init result arrays
    len = length(data)/4;
    side = zeros(1,len);
    forward = zeros(1,len);
    yaw = zeros(1,len);


    %Do actual calculations. See: "FicTrac: A visual method for tracking
    %spherical motion and generating fictive animal paths"
    for i=1:(len-5)
        current = data(i:i+3);

        w_m = alpha_.*[cos(omega),-sin(omega);sin(omega),cos(omega)]*[current(2);current(4)];

        w_mz = alpha_*(current(1)+current(3))/(2*r);

        side(i) = w_m(1);
        forward(i) = w_m(2);
        yaw(i) = w_mz;    
    end

end

function [ array_of_blocks, array_of_time ] = parseInput(filedata,timedata)
%parseInput is a function for separating blocks of raw data from each other
%return an array of strings, each containing data for one block

    filedata = transpose(filedata);
    numBlocks = strfind(filedata,'*');
    array_of_blocks = fillArray(filedata,numBlocks);
    
    timedata = transpose(timedata);
    numBlocks = strfind(timedata,'*');
    array_of_time = fillArray(timedata,numBlocks);
    
end

function [array] = fillArray(data,numBlocks)
    
    if length(numBlocks) ~= 0
        array = {1,length(numBlocks)+1};

        array{1,1} = data(1:numBlocks(1)-2);

        for i=2:(length(numBlocks))
            array{1:i} = data(numBlocks(i-1)+2:numBlocks(i)-2);
        end
        
        array{1,end} = data(numBlocks(end)+2:end);
        
    else
        array = {data};
    end
end