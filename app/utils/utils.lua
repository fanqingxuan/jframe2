local type = type
local pairs = pairs
local type = type
local mceil = math.ceil
local mfloor = math.floor
local mrandom = math.random
local mmodf = math.modf
local sgsub = string.gsub
local tinsert = table.insert
local date = require("app.libs.date")
local str = require "resty.string"
local ngx_quote_sql_str = ngx.quote_sql_str

local _M = {}

function _M.clear_slash(s)
    s, _ = sgsub(s, "(/+)", "/")
    return s
end

function _M.table_is_empty(t)
    if t == nil or _G.next(t) == nil then
        return true
    else
        return false
    end
end

function _M.merge(t1, t2)
    local res = {}
    for k,v in pairs(t1) do res[k] = v end
    for k,v in pairs(t2) do res[k] = v end
    return res
end

function _M.is_array(t)
    if type(t) ~= "table" then return false end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

function _M.mixin(a, b)
    if a and b then
        for k, v in pairs(b) do
            a[k] = b[k]
        end
    end
    return a
end

function _M.random()
    return mrandom(0, 1000)
end


function _M.now()
    local n = date()
    local result = n:fmt("%Y-%m-%d %H:%M:%S")
    return result
end

function _M.secure_str(str)
    return ngx_quote_sql_str(str)
end

function _M.split(str, delimiter)
    if not str or str == "" then return {} end
    if not delimiter or delimiter == "" then return { str } end

    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        tinsert(result, match)
    end
    return result
end


function _M.in_array(arr, val)
    if arr then
        for _, v in pairs(arr) do
            if v == val then
                return true
            end
        end
    end
    return false
end

function _M.json_encode(data, empty_table_as_object)
    local json_value
    if json.encode_empty_table_as_object then
        -- empty table encoded as array default
        json.encode_empty_table_as_object(empty_table_as_object or false) 
    end
    if require("ffi").os ~= "Windows" then
        json.encode_sparse_array(true)
    end
    pcall(function(d) json_value = json.encode(d) end, data)
    return json_value
end

function _M.json_decode(str)
    local ok, data = pcall(json.decode, str)
    if ok then
        return data
    end
end

function _M.startswith(str, substr)
    if str == nil or substr == nil then
        return false
    end
    if sfind(str, substr) ~= 1 then
        return false
    else
        return true
    end
end

function _M.endswith(str, substr)
    if str == nil or substr == nil then
        return false
    end
    local str_reverse = sreverse(str)
    local substr_reverse = sreverse(substr)
    if sfind(str_reverse, substr_reverse) ~= 1 then
        return false
    else
        return true
    end
end

function _M.trim(str, symbol)
    symbol = symbol or '%s' -- %s default match space \t \n etc..
    return (string.gsub(string.gsub(str, '^' .. symbol .. '*', ""), symbol .. '*$', ''))
end

-- sort a hashTable by key
function _M.sort_by_key(tab)
    local a = {}
    for n in pairs(tab) do
        table.insert(a, n)
    end
    table.sort(a)
    local i = 0 -- iterator variable
    local iter = function()
        -- iterator function
        i = i + 1
        if a[i] then
            return a[i], tab[a[i]]
        else
            return nil
        end
    end
    return iter
end

function _M.table_reverse(tbl)
    for i=1, math.floor(#tbl / 2) do
        tbl[i], tbl[#tbl - i + 1] = tbl[#tbl - i + 1], tbl[i]
    end
    return tbl
end

-- make up a string from array
function _M.implode(arr, symbol)
    local implode_str = ''
    symbol = symbol or ','
    for key, value in pairs(arr) do
        implode_str = implode_str .. value .. symbol
    end
    return string.sub(implode_str, 1, #implode_str - 1)
end

-- unique a array
function _M.unique(arr)
    local hash = {}
    local res = {}
    for _,v in ipairs(arr) do
        if not hash[v] then
            hash[v] = true
            table.insert(res, v)
        end
    end
    return res
end

function _M.table_remove(tab, rm)
    local result = tab
    for k, v in pairs(rm) do
        for a_k, a_v in pairs(result) do
            -- array
            if type(a_k) == 'number' then
                -- object
                if type(a_v) == 'table' then
                    result[a_k][v] = nil
                elseif v == a_v then
                    table.remove(result, a_k)
                end
            else
            -- hash array
                if v == a_k then
                    result[a_k] = nil
                end
            end
        end
    end
    return result
end

function _M.basename(str)
    local name = sgsub(str, "(.*/)(.*)", "%2")
    return name
end

function _M.dirname(str)
    if str:match(".-/.-") then
        local name = sgsub(str, "(.*/)(.*)", "%1")
        return name
    else
        return ''
    end
end

-- get the lua module name
function _M.get_lua_module_name(file_path)
    return smatch(file_path, "(.*)%.lua")
end


return _M