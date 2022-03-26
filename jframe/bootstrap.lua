local type = type

local Group = require("jframe.router.group")
local Router = require("jframe.router.router")
local Request = require("jframe.request")
local Response = require("jframe.response")
local Application = require("jframe.application")
local Wrap = require("jframe.wrap")

JFRAME_FRAMEWORK_DEBUG = false

local createApplication = function(options)
    if options and options.debug and type(options.debug) == 'boolean' then
        JFRAME_FRAMEWORK_DEBUG = options.debug
    end

    local app = Application:new()
    app:init(options)

    return app
end

local jframe = Wrap:new(createApplication, Router, Group, Request, Response)

return jframe
