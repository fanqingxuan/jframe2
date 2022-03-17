local lor = require("lor.index")
local index_router = lor:Router()


index_router:get("/", function(req, res, next)
    

    res:json({
        success = true,
        data = {
            "1",'2','3',"hello world","世界您好"
        }
    })
end)

return index_router
