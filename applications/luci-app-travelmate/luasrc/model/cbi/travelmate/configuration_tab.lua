-- Copyright 2017 Dirk Brenken (dev@brenken.org)
-- This is free software, licensed under the Apache License, Version 2.0

local fs = require("nixio.fs")
local util = require("luci.util")
local trminput = "/etc/config/travelmate"

if not nixio.fs.access(trminput) then
	m = SimpleForm("error", nil, translate("Input file not found, please check your configuration."))
	m.reset = false
	m.submit = false
	return m
end

m = SimpleForm("input", nil)
m:append(Template("travelmate/config_css"))
m.reset = false

s = m:section(SimpleSection, nil,
	translate("This form allows you to modify the content of the main travelmate configuration file (/etc/config/travelmate)."))

f = s:option(TextValue, "data")
f.rows = 20
f.rmempty = true

function f.cfgvalue()
	return nixio.fs.readfile(trminput) or ""
end

function f.write(self, section, data)
	return nixio.fs.writefile(trminput, "\n" .. util.trim(data:gsub("\r\n", "\n")) .. "\n")
end

function s.handle(self, state, data)
	return true
end

return m
