f = SimpleForm("seu-net")
f.reset = false
f.submit = false
f:append(Template("seu-net/log"))
return f
