function ip = getIPAddress()
    %Simple function for finding ip address of localhost.
    %Works on: Ubuntu 12.04 LTS,
    %%%%%%%%%%%%%%%%%%%%%%5
    %Returns IP address as string
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~,result] = system('ifconfig');
    
    starting = strfind(result,'inet addr:');
    ending = strfind(result,'  Bcast');
    
    start = starting(1)+length('inet addr:');
    
    ip = result(start:ending(1)-1);
end
