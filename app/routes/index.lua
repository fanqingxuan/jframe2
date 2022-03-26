local jframe = require("jframe.bootstrap")
local index_router = jframe:Router()
local DB = require "app.libs.db"
local db = DB:new()
local localStorage = require('app.libs.localStorage');

index_router:get("/", function(req, res, next)
    localStorage:set('b','hello');
    ret = db:delete("delete from user WHERE id=?",{'1'})
    localStorage:set("dddddd",'aaaa');
    localStorage:expire('dddddd',55555);
    localStorage:flush_all()
    res:json({
        success = true,
        data = {localStorage:get('dddddd')}
    })
end)

index_router:get('/list',function(req,res,next) 
    for i = 1,100 do 
        ngx.say(i)
    end
end)

return index_router
