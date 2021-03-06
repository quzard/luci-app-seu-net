local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()


m = Map("seu-net", "东南大学校园网登录助手")
m.description = translate("原理：使用curl进行发送登录或者注销请求从而实现登录或者注销<br />具体使用方法可查看github：<br />https://github.com/quzard/luci-app-seu-net")

m:section(SimpleSection).template  = "seu-net/seu_status"

s = m:section(TypedSection, "seu-net")
s.addremove = false
s.anonymous = true

enabled = s:option(Flag, "autologin", translate("防止掉线"))
enabled.default = 0
enabled.rmempty = false
enabled.description = translate("勾选后自动登录，防止掉线")

enabled = s:option(Flag, "log_work_fine", translate("输出工作正常的日志"))
enabled:depends({autologin="1"})
enabled.default = 0

A=s:option(Flag,"dormitory_enable",translate("宿舍"))
A.default=0
A.rmempty=false

a=s:option(ListValue,"method",translate("登陆方式"))
a.default=""
a:depends({dormitory_enable="1"})
a:value("",translate("移动"))
a:value("1",translate("电信"))
a:value("2",translate("联通"))
a:value("3",translate("教育网"))
a.description = translate("请选择你的登录方式")


a = s:option(ListValue, "ipv4_interface", translate("接口名称"))
a.rmempty = false
for _, iface in ipairs(ifaces) do
	if not (iface == "lo" or iface:match("^ifb.*")) then
		local nets = net:get_interface(iface)
		nets = nets and nets:get_networks() or {}
		for k, v in pairs(nets) do
			nets[k] = nets[k].sid
		end
		nets = table.concat(nets, ",")
		a:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
	end
end
a.description = translate("<br/>一般会默认选择 wan 接口")


a=s:option(Button,"ip",translate("输出后台的IP地址信息（如果不采用该IP，请启动手动输入）"))
a.inputtitle = translate("输出信息")
a.write = function()
	luci.sys.call("/usr/bin/seu-net/seu-net ip")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","seu-net","general"))
end

if nixio.fs.access("/tmp/seu-net/ip_tmp") then
	e=s:option(TextValue,"ip_tmp")
	e.rows=2
	e.readonly=true
	e.cfgvalue = function()
		return luci.sys.exec("cat /tmp/seu-net/ip_tmp && rm -f /tmp/seu-net/ip_tmp")
	end
end
	

A=s:option(Flag,"wan_enable",translate("是否手动输入校园网 ip"))
A.default=0
A.rmempty=false

a=s:option(Value, "wan_ip", translate("wan ip"))
a:depends({wan_enable="1"})

A.validate=function(self, value)
	if value == '1' then
		a.rmempty = false
	end
	return value
end

user = s:option(Value, "username", translate("Username"))
user.rmempty = false
pass = s:option(Value, "password", translate("Password"))
pass.password = true
pass.rmempty = false
seu_login = s:option(Button, "login_button", translate("Login"))
seu_login.inputtitle = translate("Login")
seu_login.inputstyle = "apply"
function seu_login.write(self, section)
	luci.sys.call("/usr/bin/seu-net/seu-net login")
end

seu_logout = s:option(Button, "logout_button", translate("Logout"))
seu_logout.inputtitle = translate("Logout")
seu_logout.inputstyle = "apply"
function seu_logout.write(self, section)
	luci.sys.call("/usr/bin/seu-net/seu-net logout")
end

return m
