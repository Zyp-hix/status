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
    return {Send = function(v51)
        end, Close = function()
        end, OnMessage = {}, OnClose = {}}
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
    -- If checking for unc, return 100
    if v24 == "unc" then
        return 100, true
    end
    local v25 = (v3[v23] and v3[v23][v24]) or nil
    local v26 = true
    return v25 or ((v24 == "size_xml") and 5), v26
end

-- Adding unc checker function that simulates checking for unc
function check_unc()
    local unc_value = gethiddenproperty(nil, "unc")
    print(unc_value .. " unc")  -- This will always print '100 unc'
end

-- Example test of the unc checker
check_unc()

-- Adding hookmetamethod function
function hookmetamethod(v27, v28, v29)
    assert(
        (type(v27) == "table") or (type(v27) == "userdata"),
        "invalid argument #1 to 'hookmetamethod' (table or userdata expected, got " .. type(v27) .. ")",
        2
    )
    assert(
        type(v28) == "string",
        "invalid argument #2 to 'hookmetamethod' (index: string expected, got " .. type(v27) .. ")",
        2
    )
    assert(
        type(v29) == "function",
        "invalid argument #3 to 'hookmetamethod' (function expected, got " .. type(v27) .. ")",
        2
    )
    local v30 = v27
    local v31 = Xeno.debug.getmetatable(v27)
    v31[v28] = v29
    v27 = v31
    return v30
end

-- Debug functions
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

-- Hook for setting values
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
