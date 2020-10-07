
module("luci.controller.seu-net", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/seu-net") then
		return
	end

	entry({"admin", "services", "seu-net"},firstchild(), _("东南大学校园网助手"), 50).dependent = false
	entry({"admin", "services", "seu-net", "general"},cbi("seu-net/seu-net"), _("设置"), 1)
	entry({"admin", "services", "seu-net", "log"}, form("seu-net/log"),_("日志"), 99).leaf = true
	entry({"admin", "services", "seu-net", "get_log"}, call("get_log")).leaf = true
	entry({"admin", "services", "seu-net", "clear_log"}, call("clear_log")).leaf = true
	entry({"admin", "services", "seu-net", "status"},call("act_status")).leaf=true
end

function act_status()
	local e={}
	e.running=luci.sys.call("ping -c 1 114.114.114.114 >/dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function get_log()
	luci.http.write(luci.sys.exec(
		"[ -f '/tmp/seu-net/seu-net.log' ] && cat /tmp/seu-net/seu-net.log"))
end

function clear_log()
	luci.sys.call("echo '' > /tmp/seu-net/seu-net.log")
end
