local module = {}

function module:ConvertShort(Filter_Num)
	local x = tostring(Filter_Num)
	if #x>=10 then
		local important = (#x-9)
		return x:sub(0,(important)).."."..(x:sub(#x-7,(#x-7))).."B+"
	elseif #x>= 7 then
		local important = (#x-6)
		return x:sub(0,(important)).."."..(x:sub(#x-5,(#x-5))).."M+"
	elseif #x>=4 then
		return x:sub(0,(#x-3)).."."..(x:sub(#x-2,(#x-2))).."K+"
	else
		return Filter_Num
	end
end
return module
