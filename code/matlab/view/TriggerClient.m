% CLIENT connect to a server and read a message
%
% Usage - message = client(host, port, number_of_retries)
function TriggerClient(host, port)

import java.net.Socket
import java.io.*

input_socket = [];
recording_started = false;

while true
    
    if (recording_started)
        fprintf(1, 'Recording started\n');
        break;
    end
    
    try
        % throws if unable to connect
        input_socket = Socket(host, port);
        
        % get a buffered data input stream from the socket
        input_stream   = input_socket.getInputStream;
        d_input_stream = DataInputStream(input_stream);
        
        % read data from the socket - wait a short time first
        bytes_available = input_stream.available;
        
        fprintf(1, 'Reading %d bytes\n', bytes_available);
        
        if (bytes_available == 0)
            recording_started = true;
        end
                
        % cleanup
        input_socket.close;
        recording_started = true
        
    catch
        if ~isempty(input_socket)
            input_socket.close;
        end
    end
end
end