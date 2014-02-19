function [ valid ] = validateConfigObject(config)
%Function that validates the config object to make sure that all necessary
%fields and that any values are within in their domain. This to make sure
%that an experiment can be run with the correct configuration
%
%Returns True if valid, False otherwise

    valid = true;
    try
        fprintf('values: ');
        valid = config.runnable
        valid = (config.port >0)
    catch e
        valid = false;
    end
end

