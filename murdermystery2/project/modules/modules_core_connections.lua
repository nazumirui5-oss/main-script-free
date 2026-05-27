local connections = {}
_G.LouisConnections = _G.LouisConnections or {}

function connections.SafeConnect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(_G.LouisConnections, conn)
    return conn
end

function connections.DisconnectAll()
    for _, conn in pairs(_G.LouisConnections) do
        if conn then 
            pcall(function() conn:Disconnect() end) 
        end
    end
    _G.LouisConnections = {}
end

return connections