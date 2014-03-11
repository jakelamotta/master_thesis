function [ data,concatdata ] = calcdata(output,output_time)
%Function that calculates the data for for the raw mouse input. output and
%output_time has very specific restrictions on them, see help manual for
%this. Returns data divided into blocks and the fully concatenated data
%cell. The latter is used for plotting and is not saved.
%*******************************************************
%Precondition:
%Input format 
%Output: "00000""00000""00000""00000....00000"
%Output_time: "000000""000000""000000""000000....000000"
%Blocks separated by "*"
%*******************************************************

    %Divide raw input into blocks for data and time respectively
    [datablocks,timeblocks] = parseInput(output,output_time);
    
    %Initialize temporary and persistent cells
    result = cell(1,length(datablocks));
    data = cell(4,length(datablocks));
    
    %Parsing data
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
            errordlg('Something went wrong with the data, please try again', 'Corrupt data');        
        end
        
        result{1,k} = temp;
        
        
        
        %Really result{1,k} needs to be modulo 4 but should always be that
        %when bigger then 1. If any bugs occur here it could be that
        if length(result{1,k}) > 1
            [forward,side,yaw] = convertData(result{1,k});
            
            data{1,k} = forward;
            data{2,k} = side;
            data{3,k} = yaw;

            time = [];

            %Parsing time
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
            ta = time(end)
            time(end+1) = ta;
            data{4,k} = time;
        end
        
    end
    
    %Concatenating all blocks to one for plotting purposes
    concatdata = concatBlocks(data);
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

%Function that do the actual calculation of fly movement by transforming
%the mouse input data to fly's forward,sideway and yaw delta coords
function [forward,side,yaw] = convertData(data)
    %plot(data)
    %Calibration data, hardcoded for testing purposes will be changed to
    %dynamic values later
    alpha_ = .0185;
    omega = 0;%-pi/2;
    r = 25;

    %Init result arrays
    len = length(data)/4;
    side = zeros(1,len);
    forward = zeros(1,len);
    yaw = zeros(1,len);

    data = reshape(data,4,len);
    size_ = size(data);
    
    %Do actual calculations. See: "FicTrac: A visual method for tracking
    %spherical motion and generating fictive animal paths"
    for i=1:size_(2)
        current = transpose(data(:,i));
        
        w_m = alpha_.*[cos(omega),-sin(omega);sin(omega),cos(omega)]*[current(2);current(4)];

        w_mz = alpha_*(current(1)+current(3))/(2*r);

        side(i) = w_m(1);
        forward(i) = w_m(2);
        yaw(i) = w_mz*180/pi;    
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
        array = cell(1,length(numBlocks)+1);

        array{1,1} = data(1:numBlocks(1)-2);

        for i=2:(length(numBlocks))
            array{1,i} = data(numBlocks(i-1)+2:numBlocks(i)-2);
        end
        
        array{1,end} = data(numBlocks(end)+2:end);
        
    else
        array = {data};
    end
end