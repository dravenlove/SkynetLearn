local skynet = require "skynet"
local mysql = require "skynet.db.mysql"
require "skynet.manager"	-- import skynet.register

local CMD = {}
local db

local function ping()
    while true do
        if db then
            local result = db:query("select 1;")
            if result.errno then 
                skynet.error("mysqlping  query failed, reason:" .. result.errno)
            end
        end
        skynet.sleep(1200 * 1000)
    end
end

local function query(sql)
    local result = db:query(sql)
    if result.errno then
        skynet.error("mysql query failed, reason:" .. result.errno)
        return false
    end
    return true, result
end

function CMD.open(host, port, database, user, passward, charset)
    -- local function on_connect(database)
	-- 	database:query("set charset utf8mb4");
    -- end
    db = mysql.connect({
        host = host,
        port = port,
		database = database,
		user = user,
		password = passward,
        charset = charset,
		max_packet_size = 1024 * 1024
    })
    if not db then
		skynet.error("failed to connect to mysql, ip:" .. host)
	end
    skynet.error("success connect to mysql, ip:" .. host)
    skynet.fork(ping())
end

function CMD.close()
    if db then
        db:disconnect()
        db = nil
    end
end

function CMD.insert(table_name, row)
    local keys = {}
    local values = {}
    for k, v in pairs(row) do
        skynet.error("fuck fuck fuck!" .. k .. " type:" .. type(k))
        table.insert(keys, k)
        if type(v) == "string" then
            v = mysql.quote_sql_str(v)
        end
        table.insert(values, v)
    end
    local keystring = table.concat(keys, ",")
    local valuestring = table.concat(values, ",")
    local sql = string.format("INSERT INTO %s(%s) VALUES(%s);", table_name, keystring, valuestring)
    query(sql)
end

function CMD.delete(table, key, value)
    local sql = string.format("DELETE FROM %s WHERE %s = %s;", table, key, value)
    query(sql)
end

function CMD.update(table, key, value, row)
    local new_row = {}
    for k, v in pairs(row) do
        if type(v) == "string" then
            v = mysql.quote_sql_str(v)
        end
        table.insert(new_row, k.."="..v)
    end
    new_row = table.concat(new_row, ",")
    local sql = string.format("UPDATE %s set %s WHERE %s = %s;", table, new_row, key, value)
    query(sql)
end

function CMD.select_key(table, key, value)
    local sql = string.format("SELECT * FROM %s WHERE %s = %s;",
     table, key, value)
    return query(sql)
end

function CMD.select_all(table)
    local sql = string.format("SELECT * FROM %s;", table)
    return query(sql)
end

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
