function [output,output_time] = opentempdata()
        
        output = '';
        output_time = '';
        try
                fid = fopen(getpath('tempdata.txt','code'),'r');
                output = fread(fid,'uint8=>char');

                fid = fopen(getpath('temptime.txt','code'),'r');
                output_time = fread(fid,'uint8=>char');
            catch e
                e.message
                %errordlg('Data file couldnt be found');
        end
        
        
end
    
