-- local user_router = require("app.routes.user")
local error_router = require("app.routes.error")
local index_router = require("app.routes.index")
local utils = require("app.utils.utils")

return function(app)
    app:get("/",function(req,res,next) 

        local str = " he llo "
        local s = utils.trim(str)
        res:send(#s)
    end)
    app:use("/error", error_router())
    app:use("/index", index_router())
    -- app:use("/user", user_router())
end

