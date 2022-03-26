local pairs = pairs
local ipairs = ipairs
local jframe = require("jframe.bootstrap")
local errorRouter = jframe:Router()


errorRouter:get("/", function(req, res, next)
    res:render("error", {
    	errMsg = req.query.errMsg -- injected by the invoke request
    })
end)


return errorRouter