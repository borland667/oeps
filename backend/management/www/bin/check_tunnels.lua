#!/usr/bin/lua

-- ElCheapo mysql interface
require "luasql.mysql"


local c=require("oeps.config")
local co=c.getconfig()

local exitcode=0
local status="OK"
local message=""
local dbi=luasql.mysql()
local dbh=dbi:connect(co.DBNAME,co.DBUSER,co.DBPASSWORD)
local res=dbh:execute([[
select name,state from ap where state != "UP" and adminstate = "PRODUCTION" and TIMESTAMPDIFF(DAY,lastcontact,NOW())<7
]])
row=res:fetch({},"a")
while row
do
	exitcode=1
	message=message .. " " .. row.name .. ":" ..row.state
	status="CRITICAL:"
	row=res:fetch({},"a")
end


res:close()
dbh:close()
dbi:close()
print(status .. message)
os.exit(exitcode)