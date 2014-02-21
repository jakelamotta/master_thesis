function [ result ] = calcdata(output)
    
    blocks = parseInput(output);

    
    result = cell(1,length(blocks));
    
    for i=1:length(blocks)
        

        temp = [0];
        time = [1];

        try        
            block = blocks(i);
            for i=1:(length(block)/7)-1
                if i == 1
                    str_ = strcat(block(2),block(3),block(4),block(5),block(6));
                    temp(1) = str2num(str_);
                    a = 9;
                end
                time(end+1) = i;
                str_ = strcat(block(a),block(a+1),block(a+2),block(a+3),block(a+4));
                temp(end+1) = str2num(str_);
                a = a+7;

            end
        catch Exception
            %output
            errordlg('Something went wrong with the data, please try again', 'Corrupt data');        
        end
        
        result{1,i} = temp;
    end
    
    result    
%         try        
% 
%             for i=1:(length(output_time)/8)-1
%                 if i == 1
%                     str_ = strcat(output_time(2),output_time(3),output_time(4),output_time(5),output_time(6),output_time(7));
%                     time(1) = str2num(str_);
%                     a = 10;
%                 end
% 
%                 str_ = strcat(output_time(a),output_time(a+1),output_time(a+2),output_time(a+3),output_time(a+4),output_time(a+5));
%                 time(end+1) = str2num(str_);
%                 a = a+8;
%             end
%         catch Exception
%             
%             errordlg('Something went wrong with the timestamps, please try again', 'Corrupt data');        
%         end
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

        %Save data to file with current date and time as filename
        %c = clock;
        %filename = strcat(int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'.mat');
        %save(filename,'result');


end

