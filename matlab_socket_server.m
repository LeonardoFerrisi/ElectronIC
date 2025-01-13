% MATLAB Server Script
% Author:  Leonardo Ferrisi
% Contact: Leonardo.Ferrisi@utah.edu


function matlab_socket_server()
    % Define the port for the server
    port = 3000;

    % Create a TCP/IP server
    server = tcpserver("0.0.0.0", port, "ConnectionChangedFcn", @connectionHandler);

    fprintf("Server is running on port %d...\n", port);

    % Keep the server running indefinitely
    while true
        pause(1);
    end

    % Yes... this loop is a little ugly, will optimize in the future
    function connectionHandler(src, ~)
        % Connection changed event
        while src.Connected
            % Check if there is data available
            if src.BytesAvailable > 0
                % Read incoming data
                data = readline(src);
                fprintf("Data received from: %s\n", src.ClientAddress);
                fprintf("Data is: %s\n", data);

                % Process the received command
                response = processCommand(data);
                fprintf("Evaluated response is %s\n", response);

                % Send response back to the client
                writeline(src, response);
            end
        end
    end
end

function response = processCommand(command)
    % Process incoming commands
    % Example: Basic mathematical operations
    try
        % Evaluate the received command
        result = eval(command);

        % Prepare the response
        if isnumeric(result) || ischar(result)
            % structs are basically jsons, and can be encoded as such
            response = jsonencode(struct("status", "success", "result", result));
        else
            response = jsonencode(struct("status", "success", "result", "Command executed successfully."));
        end
    catch ME
        % Handle errors
        response = jsonencode(struct("status", "error", "message", ME.message));
    end
end
