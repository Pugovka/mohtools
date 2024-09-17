local neatjson = require("bfilejson")

function convertTableToJsonString(data)
    return (neatjson(data, {sort = true, wrap = 40}))
end

function additionArray(table, to)

    if table == nil then return to end
    for k, v in pairs(table) do
        if type(v) == "table" then
            if to[k] == nil then to[k] = {} end
            for k1, v1 in pairs(v) do
                if type(v1) == "table" then
                    if to[k][k1] == nil then to[k][k1] = {} end
                    for k2, v2 in pairs(v1) do
                        if type(v2) == "table" then
                            if to[k][k1][k2] == nil then to[k][k1][k2] = {} end  
                            for k3, v3 in pairs(v2) do
                                if type(v3) == "table" then
                                    if to[k][k1][k2][k3] == nil then to[k][k1][k2][k3] = {} end
                                else to[k][k1][k2][k3] = v3 end
                            end
                        else to[k][k1][k2] = v2 end
                    end
                else to[k][k1] = v1 end
            end
        else to[k] = v end
    end
    return to
end

local mod = {}

mod.loadCfg = function(t, f, s)

    local path = "moonloader/"

    if not doesDirectoryExist(path) then createDirectory(path) end

    local fpath = path.."/"..f

    if doesFileExist(fpath) then
        local file = io.open(fpath, "r")
        local dora = {}
        if file then
            dora = decodeJson(file:read("*a"))
            if dora == nil then
                file:write(convertTableToJsonString(t))
                dora = t
            else
                if s then dora = additionArray(dora, t) end
            end
            file:close()
        else
            local file = io.open(fpath, "w")
            file:write(convertTableToJsonString(t))
            file:close()
            print(convertTableToJsonString(t))
            dora = t
        end
        return dora
    else
        local file = io.open(fpath, "w")
        file:write(convertTableToJsonString(t))
        file:close()
        return t
    end
end


mod.saveCfg = function(t, f)

    local path = "moonloader/"

    if not doesDirectoryExist(path) then createDirectory(path) end

    local fpath = path.."/"..f

    local res, jsonData = pcall(convertTableToJsonString, t)
    if res then
        local file = io.open(fpath, "w")
        file:write(jsonData)
        file:close()
    else
        print(("Не удалось сохранить %s"):format(fpath))
    end
end

return mod