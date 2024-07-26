function sxcalc(input)
	-- input 不包含命令，比如输入 cl5+5，input 就为 5+5，不会包含 cl 前缀。
	local env = setmetatable({}, { __index = _G })
	local func, err = load("return " .. input, "expression", "t", env)

	if func then
		local success, result = pcall(func)
		if success then
			return tostring(result)
		else
			return "表达式不合法"
		end
	else
		return "表达式不合法"
	end
end

-- 此处 leading 使用了 alpha，因为输入的表达式中会含有数字，如果使用数字作为快捷键可能会导致冲突，所以只能使用字母选择
ime.register_command("cl", "sxcalc", "数学计算", "alpha", "进行简单的数学计算机")
