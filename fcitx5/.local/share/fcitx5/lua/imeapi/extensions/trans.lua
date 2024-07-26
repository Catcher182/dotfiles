-- sudo luarocks install json.lua
-- sudo luarocks install md5
-- sudo luarocks install luasocket
-- sudo luarocks install luasec
local fcitx = require("fcitx")
local http = require("socket.http")
local ltn12 = require("ltn12")
local md5 = require("md5")
local json = require("json")

package.path = package.path .. ";/home/dawn/.config/?.lua"
local config = require("trans-config")

-- 注册我们的事件监听器以及转换器
fcitx.watchEvent(fcitx.EventType.KeyEvent, "key_event")
fcitx.addConverter("trans")

-- 用于判断转换器是否需要开启
local enable = false

function key_event(sym, state, release)
	-- Ctrl + Alt + Space
	if state == fcitx.KeyState.Ctrl_Alt and sym == 32 and not release then
		enable = not enable
		if enable then
			io.popen("notify-send '翻译模式开启'")
		else
			io.popen("notify-send '翻译模式关闭'")
		end
	end
	return false
end

local appid = config.appid
local key = config.key

local function isChinese(str)
	return string.match(str, "[\x80-\xff]+")
end

local function getBaiduTranslation(text, from, to)
	local salt = math.random(1, 9999)
	local sign = md5.sumhexa(appid .. text .. salt .. key)
	local url = "http://api.fanyi.baidu.com/api/trans/vip/translate?q="
		.. text
		.. "&from="
		.. from
		.. "&to="
		.. to
		.. "&appid="
		.. appid
		.. "&salt="
		.. salt
		.. "&sign="
		.. sign

	local response_body = {}
	local _, status = http.request({
		url = url,
		method = "GET",
		sink = ltn12.sink.table(response_body),
	})

	if status == 200 then
		local result_json = table.concat(response_body)
		local result = json.decode(result_json)
		return result
	else
		return nil
	end
end

function trans(input)
	if enable then
		local inputText = input

		-- 判断是中文还是英文
		local fromLang
		local toLang
		if isChinese(inputText) then
			fromLang = "zh"
			toLang = "en"
		else
			fromLang = "en"
			toLang = "zh"
		end

		local translation = getBaiduTranslation(inputText, fromLang, toLang)

		if translation and translation.trans_result and translation.trans_result[1] then
			if fromLang == "zh" then
				-- print("原文：" .. inputText)
				-- print("译文：" .. translation.trans_result[1].dst)
				local str = translation.trans_result[1].dst:gsub("%s*$", "")
				str = str .. " "
				input = str
			else
				-- print("Original: " .. inputText)
				-- print("Translation: " .. translation.trans_result[1].dst)
				local str = translation.trans_result[1].dst:gsub("%s*$", "")
				input = str
			end
		end
	end

	return input
end
