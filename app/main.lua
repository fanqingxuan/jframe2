local sfind = string.find
local lor = require("lor.index")
local config = require("app.config.config")
local reponse_time_middleware = require("app.middleware.response_time")
local powered_by_middleware = require("app.middleware.powered_by")

local response = require("lor.lib.response")
local ok,router = pcall(require,'app.router')
if not ok then
    return response:status(500):json({
        success = false,
        msg = "500! server error."
    })
end

local app = lor()


-- app:use(reponse_time_middleware({
--     digits = 0,
--     header = 'X-Response-Time',
--     suffix = true
-- }))

-- filter: add response header
app:use(powered_by_middleware('Lor Framework'))


router(app) -- business routers and routes

-- error handle middleware
app:erroruse(function(err, req, res, next)
	ngx.log(ngx.ERR, err)
	
	-- 404 error
	if req:is_found() ~= true then
		if sfind(req.headers["Accept"], "application/json") then
			res:status(404):json({
				success = false,
				msg = "404! sorry, not found."
			})
		else
			res:status(404):send("404! sorry, not found.")
		end
	else
		if sfind(req.headers["Accept"], "application/json") then
			res:status(500):json({
				success = false,
				msg = "500! server error."
			})
		else
			res:status(500):send("server error")
		end
	end
end)

app:run()
