%Configuration class, singleton object that encapsulates configuration
%parameters. 
classdef Configuration < handle
    %CONFIGURATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public',SetAccess = 'private')
        trigger;
        port;
        timer;
        runnable;
        time;
        savepath;
    end
    
    methods (Access = 'public')
        
        %Constructor for the config object setting default values which are
        %later updated to user custom values
        function this = Configuration()
            this.port = 4444;
            this.trigger = 'no';
            this.runnable = true;
            time = 3000;
            this.savepath = getpath('','data');
        end   
        
        %%%%%%%%%%SETTERS%%%%%%%%%%%%%%%%
        function trigger = setNetworkTrigger(this,t)
            this.trigger = t;
        end
        
        function runnable = setRunnable(this,bool)
            this.runnable = bool;
        end
        
        function savepath = setPath(this,path)
            %Path must exist
            if exist(path,'dir')
                this.savepath = path;
            end
        end
        
        function time = setTime(this,t)
            %Time must be a positive integer
            if str2num(t) > 1
                this.time = t;
            else
                this.time = 3000;
            end
            
        end
        
        function port = setPort(this,p)
            %Validates portnumber before setting it
            if str2num(p) > 1024 && str2num(p) < 65535    
                this.port = str2num(p);
            else
                this.port = 4444;
            end
        end
    end
    
end

