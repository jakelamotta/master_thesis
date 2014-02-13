%Configuration class, singleton object that encapsulates configuration
%parameters. 
classdef Configuration < handle
    %CONFIGURATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public',SetAccess = 'private')
        regMouse;
        sensor1;
        sensor2;
        network_trigger;
        timer_trigger;
        port;
    end
    
    methods (Access = 'public')
        
        %Constructor for the config object
        function this = Configuration(mouse,s1,s2)
            this.regMouse = mouse;
            this.sensor1 = s1;
            this.sensor2 = s2;
            this.port = 3000;
        end     
        
        %%%%%%%%%%SETTERS%%%%%%%%%%%%%%%%
        function setRegMouse(mouse,d)
            mouse.regMouse = d;
        end
        
        function sensor1 = setSensor1(mouse)
            sensor1 = mouse;
        end
        
        function sensor2 = setSensor2(mouse,d,s)
            sensor2 = mouse;
        end
        
        function network_trigger = setNetworkTrigger(m)
            network_trigger = true;
            m.network_trigger = true;
        end
        
        function enableTimerTrigger(this)
            this.timer_trigger = true;
        end
    end
    
end

