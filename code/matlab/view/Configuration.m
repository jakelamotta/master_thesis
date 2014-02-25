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
        
        %Constructor for the config object
        function this = Configuration()
            this.port = 4444;
            this.trigger = 'timer';
            this.runnable = true;
            time = 3000;
            this.savepath = '/home/kristian/master_thesis/data';
        end     
        
        %%%%%%%%%%SETTERS%%%%%%%%%%%%%%%%
        function trigger = setNetworkTrigger(this,t)
            this.trigger = t;
        end
        
        function runnable = setRunnable(this,bool)
            this.runnable = bool;
        end
        
        function savepath = setPath(this,path)
            this.savepath = path;
        end
    end
    
end

