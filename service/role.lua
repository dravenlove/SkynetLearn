local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local CMD = {}

skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = assert(CMD[cmd], "dbserver have not found cmd defined:" .. (cmd or "nil"))
        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
	skynet.register "DBSERVER"
end)
