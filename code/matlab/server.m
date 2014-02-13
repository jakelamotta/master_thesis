function server(output_port,number_of_retries)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    import java.net.ServerSocket
    import java.io.*
        
    retry = 0;
    server_socket  = [];
    output_socket  = [];
    signal_recieved = false;
    message = 1;
    
    while true

        retry = retry + 1;

        try
            if ((number_of_retries > 0) && (retry > number_of_retries) && signal_recieved == false)
                fprintf(1, 'Too many retries\n');
                break;
            end

  %          fprintf(1, ['Try %d waiting for client to connect to this ' ...
  %                      'host on port : %d\n'], retry, output_port);

            % wait for 1 second for client to connect server socket
            server_socket = ServerSocket(output_port);
            server_socket.setSoTimeout(1000);

            output_socket = server_socket.accept;

 %           fprintf(1, 'Client connected\n');

            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);

            % output the data over the DataOutputStream
            % Convert to stream of bytes
%            fprintf(1, 'Writing %d bytes\n', length(message))
            d_output_stream.writeBytes(char(message));
            d_output_stream.flush;
            
            % clean up
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
            pause(.01);
        end
    end


end

