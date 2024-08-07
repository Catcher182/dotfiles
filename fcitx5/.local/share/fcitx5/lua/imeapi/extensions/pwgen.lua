function password_gen(pw_len)
	pw_len = tonumber(pw_len) or 8
	local passwords = {}
	local pw_seed = {
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
	}
	local seed_len = #pw_seed

	math.randomseed(os.time())

	for _ = 1, 3 do
		local pw_tmp = ""
		for _ = 1, pw_len do
			pw_tmp = pw_tmp .. pw_seed[math.random(1, seed_len)]
		end
		table.insert(passwords, pw_tmp)
	end

	return passwords
end

ime.register_command("pw", "password_gen", "generate random passwords", "alpha")
ime.register_trigger("password_gen", "generate random passwords", {}, { "密码" })
