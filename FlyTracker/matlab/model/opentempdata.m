function [output,output_time] = opentempdata()
%Open and reads temporary data files

        output = '';
        output_time = '';
        
        try
            fid = fopen(getpath('tempdata.txt','data'),'r');
            output = fread(fid,'uint8=>char');

            fid = fopen(getpath('temptime.txt','data'),'r');
            output_time = fread(fid,'uint8=>char');
        catch e
            e.message
        end        
end