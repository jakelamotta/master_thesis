function [ valid ] = validateConfigObject(config)
%Function that validates the config object to make sure that all necessary
%fields are set and that all values are within in their domain. This to make sure
%that an experiment cant be run without a correct configuration
%
%Returns True if valid, False otherwise

    valid = true;
    
    try
        valid = (config.port >0) && exist(config.savepath,'dir');
    catch e
        valid = false;
    end
end

