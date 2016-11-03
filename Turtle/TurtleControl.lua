totalRequests = 0
rednet = {}

function rednet.open(v)
	
end

function rednet.isOpen()
	return false
end

sides = {"left","right","front","back"}
opened = false;
for i,v in pairs(sides) do
	rednet.open(v)
	if rednet.isOpen() then
		break;
	end
	
	if v == sides[#sides] then
		error("No Modem Attached");
	end
end