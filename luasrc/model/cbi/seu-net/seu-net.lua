net = require "luci.model.network".init()
sys = require "luci.sys"
ifaces = sys.net:devices()


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

A=s:option(Flag,"wan_enable",translate("是否手动输入wan ip"))
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
