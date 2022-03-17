-- local user_router = require("app.routes.user")
local error_router = require("app.routes.error")
local index_router = require("app.routes.index")



return function(app)
    app:get("/",function(req,res,next) 
        res:send("hello world,世界您好")
    end)
    app:use("/error", error_router())
    app:use("/index", index_router())
    -- app:use("/user", user_router())
end

