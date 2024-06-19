local mp = require("mp")
local msg = require("mp.msg")
local utils = require("mp.utils")

--this platform test was taken from mpv's console.lua
local o = {}
local PLATFORM_WINDOWS = mp.get_property_native("options/vo-mmcss-profile", o) ~= o

local sub_extensions = {
	etf = true,
	etf8 = true,
	["utf-8"] = true,
	idx = true,
	sub = true,
	srt = true,
	rt = true,
	ssa = true,
	ass = true,
	mks = true,
	vtt = true,
	sup = true,
	scc = true,
	smi = true,
	lrc = true,
	pgs = true,
}

local sub_auto

mp.observe_property("sub-auto", "native", function(_, v)
	sub_auto = v
end)

--decodes a URL address
--this piece of code was taken from: https://stackoverflow.com/questions/20405985/lua-decodeuri-luvit/20406960#20406960
local decodeURI
do
	local char, gsub, tonumber = string.char, string.gsub, tonumber
	local function _(hex)
		return char(tonumber(hex, 16))
	end

	function decodeURI(s)
		s = gsub(s, "%%(%x%x)", _)
		return s
	end
end

--returns the protocol scheme of the given url, or nil if there is none
local function get_protocol(filename, def)
	return string.lower(filename):match("^(%a[%w+-.]*)://") or def
end

--returns the file extension of the given file
local function get_extension(filename, def)
	return string.lower(filename):match("%.([^%./]+)$") or def
end

local function remove_extension(path)
	return string.match(path, "(.*)%.[^%./]+$")
end

local function is_relative(path)
	if PLATFORM_WINDOWS then
		return not string.find(path, "^[A-Z]:[/\\]")
	else
		return not string.find(path, "^/")
	end
end

local counter = 0
local function get_list(directory, cb)
	local script_message = "track-loader/file-browser/" .. counter
	counter = counter + 1

	mp.register_script_message(script_message, function(l, o)
		mp.unregister_script_message(script_message)

		if not l and not o then
			msg.error("file-browser is not running")
			cb(nil, nil)
			return
		end

		if l == "" or o == "" then
			msg.error("file-browser failed to read directory", directory)
			cb(nil, nil)
			return --hook:cont()
		end

		local list = utils.parse_json(l)
		local opts = utils.parse_json(o)

		cb(list, opts)
	end)

	mp.commandv("script-message-to", "file_browser", "get-directory-contents", directory, script_message)
end

local function get_all_lists(hook, dirs)
	local co = coroutine.running()
	local full_list = {}

	for i, dir in ipairs(dirs) do
		if not string.find(dir, "/$") then
			dir = dir .. "/"
		end

		get_list(dir, function(list, opts)
			if list and opts and not opts.directory then
				for j, item in ipairs(list) do
					local name = (item.label or item.name)

					if sub_extensions[get_extension(name, ""):lower()] then
						local path = item.path or (dir .. name)

						table.insert(full_list, path)
					end
				end
			end
			local success, err = coroutine.resume(co)
			if not success then
				msg.error(err)
				hook:cont()
			end
		end)
	end

	-- blocking until all of the paths have been loaded
	for i = 1, #dirs do
		coroutine.yield()
	end

	return full_list
end

local function match(path)
	if sub_auto == "all" then
		return true
	end

	if sub_auto == "exact" then
		local filename = mp.get_property("filename/no-ext", "")
		local _, name = utils.split_path(path)
		name = remove_extension(name)

		if name == filename then
			return true
		end
		if decodeURI(name) == filename then
			return true
		end
	end

	if sub_auto == "fuzzy" then
		local filename = mp.get_property("filename/no-ext", "")

		if string.find(path, filename, 1, true) then
			return true
		end
		if string.find(decodeURI(path), filename, 1, true) then
			return true
		end
	end

	return false
end

local function main(hook)
	local path = mp.get_property("path")
	if not get_protocol(path) then
		return
	end
	local dir, name = utils.split_path(path)

	local sub_paths = mp.get_property_native("sub-file-paths", nil)
	if not sub_paths then
		sub_paths = {}
	end

	-- initialise the non-native paths with the current directory
	local non_native_paths = { dir }
	for i, v in ipairs(sub_paths) do
		v = mp.command_native({ "expand-path", v })

		if is_relative(v) then
			v = dir .. v
			table.insert(non_native_paths, v)
		elseif get_protocol(v) then
			table.insert(non_native_paths, v)
		end
	end

	local track_paths = get_all_lists(hook, non_native_paths)

	for i, v in ipairs(track_paths) do
		if match(v) then
			mp.commandv("sub-add", v, "auto")
		end
	end
end

mp.add_hook("on_preloaded", 10, function(hook)
	if sub_auto == "no" then
		return
	end
	hook:defer()

	local co = coroutine.create(function()
		main(hook)
		hook:cont()
	end)

	local success, err = coroutine.resume(co, hook)
	if not success then
		msg.error(err)
		hook:cont()
	end
end)
