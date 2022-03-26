local Object = require "app.libs.classic"
local ngx  = ngx
local localStorage = ngx.shared.localStorage

-- shared当做本地缓存，分开写的目的是便于编辑器提示
local _M = {
    version = '0.1.0'
}

local function transform_result(result,err)
    if not result and err then
        ngx.log(ngx.ERR," ngx.shared.localStorage err reason:",err)
    end
    return result
end

function _M:set(key,val)
    return transform_result(localStorage:set(key,val))
end

function _M:get(key)
    return transform_result(localStorage:get(key))
end

function _M:add(key,val,exptime)
    return transform_result(localStorage:add(key,val,exptime))
end

function _M:replace(key,val,exptime)
    return transform_result(localStorage:replace(key,val,exptime))
end

function _M:delete(key)
    return transform_result(localStorage:delete(key))
end

function _M:incr(key,val)
    val = val or 0
    return transform_result(localStorage:incr(key,1,val))
end

function _M:lpush(key,val)
    return transform_result(localStorage:lpush(key,val))
end

function _M:rpush(key,val)
    return transform_result(localStorage:rpush(key,val))
end

function _M:lpop(key)
    return transform_result(localStorage:lpop(key))
end

function _M:rpop(key)
    return transform_result(localStorage:rpop(key))
end

function _M:llen(key)
    return transform_result(localStorage:llen(key))
end

function _M:ttl(key)
    return transform_result(localStorage:ttl(key))
end

function _M:expire(key,exptime)
    return transform_result(localStorage:expire(key,exptime))
end

function _M:flush_all()
    local result,err = localStorage:flush_all()
    localStorage:flush_expired()
    return transform_result(result,err)
end

return _M