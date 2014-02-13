function TriggerServer(output_port)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    import java.net.ServerSocket
    import java.io.*
        
    server_socket  = [];
    output_socket  = [];
    signal_recieved = false;
    message = 2;
    t = 0;
    
    while true
        try
            if (signal_recieved == true)
                fprintf(1, 'Trigger recieved\n');
                break;
            end

            % wait for 1 second for client to connect server socket
            server_socket = ServerSocket(output_port);
            
            output_socket = server_socket.accept;

            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);

            % output the data over the DataOutputStream
            % Convert to stream of bytes
            %fprintf(1, 'Writing %d bytes\n', length(message))
            d_output_stream.writeBytes(char(message));
            d_output_stream.flush;
            
            % clean up
            signal_recieved = true;
            server_socket.close;
            output_socket.close;            
        catch
            if ~isempty(server_socket)
                server_socket.close
            end

            if ~isempty(output_socket)
                output_socket.close
            end

            % pause before retrying
        end
    end

end

