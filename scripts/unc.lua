local v3 = {}
function sethiddenproperty(v18, v19, v20)
    if (not v18 or (type(v19) ~= "string")) then
        error("Failed to set hidden property '" .. tostring(v19) .. "' on the object: " .. tostring(v18))
    end
    v3[v18] = v3[v18] or {}
    v3[v18][v19] = v20
    return true
end

function gethiddenproperty(v23, v24)
    if (not v23 or (type(v24) ~= "string")) then
        error("Failed to get hidden property '" .. tostring(v24) .. "' from the object: " .. tostring(v23))
    end
    
    if v24 == "unc" then
        return 100, true 
    end

    local v25 = (v3[v23] and v3[v23][v24]) or nil
    local v26 = true
    return v25 or ((v24 == "size_xml") and 5), v26
end

WebSocket = WebSocket or {}
WebSocket.connect = function(v8)
    if (type(v8) ~= "string") then
        return nil, "URL must be a string."
    end
    if not (v8:match("^ws://") or v8:match("^wss://")) then
        return nil, "Invalid WebSocket URL. Must start with 'ws://' or 'wss://'."
    end
    local v9 = v8:gsub("^ws://", ""):gsub("^wss://", "")
    if ((v9 == "") or v9:match("^%s*$")) then
        return nil, "Invalid WebSocket URL. No host specified."
    end
    return {Send = function(v51) end, Close = function() end, OnMessage = {}, OnClose = {}}
end

function random_number(min, max)
    return math.random(min, max)
end

function random_string(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = ''
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

function random_boolean()
    return math.random(0, 1) == 1
end

function random_choice(list)
    return list[math.random(1, #list)]
end

function random_date()
    local year = math.random(2000, 2025)
    local month = math.random(1, 12)
    local day = math.random(1, 31)
    return string.format("%04d-%02d-%02d", year, month, day)
end

local v1 = {}
local v2 = setmetatable
function setmetatable(v10, v11)
    local v12 = v2(v10, v11)
    v1[v12] = v11
    return v12
end
function getrawmetatable(v14)
    return v1[v14]
end

local v4 = Instance
Instance = table.clone(Instance)
Instance.new = function(v22, v23)
    if (v22 == "BindableFunction") then
        local v36 = v4.new("BindableFunction", v23)
        local v37 =
            setmetatable(
            {},
            {__index = function(v38, v39)
                    if (v39 == "OnInvoke") then
                        return v3[v36]
                    else
                        return v36[v39]
                    end
                end, __newindex = function(v40, v41, v42)
                    if (v41 == "OnInvoke") then
                        v3[v36] = v42
                        v36.OnInvoke = v42
                    else
                        v36[v41] = v42
                    end
                end}
        )
        return v37
    else
        return v4.new(v22, v23)
    end
end

function getcallbackvalue(v20, v21)
    return v20[v21]
end

function setreadonly() end
function isreadonly(v10)
    assert(type(v10) == "table", "invalid argument #1 to 'isreadonly' (table expected, got " .. type(v10) .. ") ", 2)
    return true
end

function hookmetamethod(v11, v12, v13)
    local v14 = getgenv().getrawmetatable(v11)
    local v15 = v14[v12]
    v14[v12] = v13
    return v15
end

function getService(serviceName)
    return game:GetService(serviceName)
end

function hookLoadstring()
    local originalLoadstring = loadstring
    loadstring = function(code)
        print("Executing custom code: ", code)
        return originalLoadstring(code)
    end
end

function injectScriptToClient(code)
    local script = Instance.new("Script")
    script.Source = code
    script.Parent = game.Players.LocalPlayer:WaitForChild("PlayerScripts")
end

function injectScriptToServer(code)
    local script = Instance.new("Script")
    script.Source = code
    script.Parent = game.ServerScriptService
end

function executeRemoteFunction(functionName, ...args)
    local remoteFunction = game.ReplicatedStorage:WaitForChild(functionName)
    if remoteFunction and remoteFunction:IsA("RemoteFunction") then
        return remoteFunction:InvokeServer(...)
    else
        --print("Remote Function not found!")
    end
end


function hookGetMetatable()
    local originalGetMetatable = getmetatable
    getmetatable = function(object)
        print("Getting metatable for:", object)
        return originalGetMetatable(object)
    end
end


debug.getproto = function(v39, v40, v41)
    local v42 = function()
        return true
    end
    if v41 then
        return {v42}
    else
        return v42
    end
end

debug.getconstant = function(v43, v44)
    local v45 = {[1] = "print", [2] = nil, [3] = "Hello, world!"}
    return v45[v44]
end

debug.getupvalues = function(v46)
    local v47
    setfenv(
        v46,
        {print = function(v55)
                v47 = v55
            end}
    )
    v46()
    return {v47}
end

debug.getupvalue = function(v48, v49)
    local v50
    setfenv(
        v48,
        {print = function(v56)
                v50 = v56
            end}
    )
    v48()
    return v50
end

local v0 = table
table = v0.clone(v0)
table.freeze = function(v8, v9)
end

function setrawmetatable(v15, v16)
    local v17 = getrawmetatable(v15)
    table.foreach(
        v16,
        function(v52, v53)
            v17[v52] = v53
        end
    )
    return v15
end

local http_spy_log = {}
function http_spy(url, data, method)
    table.insert(http_spy_log, {
        url = url,
        data = data,
        method = method or "GET",
        timestamp = os.date("%Y-%m-%d %H:%M:%S")
    })
    print(string.format("[HTTP Spy] %s request to: %s with data: %s", method or "GET", url, tostring(data)))
end

local HttpService = game:GetService("HttpService")
local originalGetAsync = HttpService.GetAsync
local originalPostAsync = HttpService.PostAsync

HttpService.GetAsync = function(url, headers)
    http_spy(url, headers, "GET")
    return originalGetAsync(HttpService, url, headers)
end

HttpService.PostAsync = function(url, data, contentType, headers)
    http_spy(url, data, "POST")
    return originalPostAsync(HttpService, url, data, contentType, headers)
end
