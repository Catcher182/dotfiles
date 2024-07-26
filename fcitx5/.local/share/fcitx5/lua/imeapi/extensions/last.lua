function last()
	return ime.get_last_commit()
end
ime.register_trigger("last", "get last commit", {}, { "重复" })
