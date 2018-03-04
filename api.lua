local config = loadfile("./config.lua")()
local URL = require "socket.url"
local https = require "ssl.https"
local serpent = require "serpent"
local json = require "JSON"
local JSON = require "cjson"
local token = config.ApiBotToken
local url = 'https://api.telegram.org/bot' .. token
local offset = 0
local redis = require('redis')
local redis = redis.connect('127.0.0.1', 6379)
local ChannelLink = config.Channel_Link
function is_mod(chat,user)
sudo = config.SudoUser
Cli = config.CliBotId
  local var = false
  for v,_user in pairs(sudo) do
    if _user == user then
      var = true
    end
  end
 local hash = redis:sismember('owners:'..chat,user)
 if hash then
 var = true
 end
 local hash2 = redis:sismember('mods:'..chat,user)
 if hash2 then
 var = true
 end
 return var
 end
function is_peyman(user)
  local var = false
  if user == tonumber(502443907) then
    var = true
  end
  return var
end
--*******************************************--
local function getUpdates()
  local response = {}
  local success, code, headers, status  = https.request{
    url = url .. '/getUpdates?timeout=20&limit=1&offset=' .. offset,
    method = "POST",
    sink = ltn12.sink.table(response),
  }

  local body = table.concat(response or {"no response"})
  if (success == 1) then
    return json:decode(body)
  else
    return nil, "Request Error"
  end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end 
function send_msg(chat_id, text, reply_to_message_id, markdown)
  local url = url .. "/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text)
  if reply_to_message_id then
    url = url .. "&reply_to_message_id=" .. reply_to_message_id
  end
  if markdown == "md" or markdown == "markdown" then
    url = url .. "&parse_mode=Markdown"
  elseif markdown == "html" then
    url = url .. "&parse_mode=HTML"
  end
  https.request(url)
end

function sendmsg(chat,text,keyboard)
if keyboard then
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text=' ..URL.escape(text)..'&parse_mode=html'
end
https.request(urlk)
end
 function edit( message_id, text, keyboard)
  local urlk = url .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true&parse_mode=Markdown'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , parse_mode , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
         results[1].parse_mode = parse_mode
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end

function settings(chat,value) 
local hash = 'settings:'..chat..':'..value
   if value == 'file' then
      text = 'فایل'
   elseif value == 'keyboard' then
    text = 'کیبورد شیشه ای'
  elseif value == 'links' then
    text = 'لینک'
  elseif value == 'spam' then
    text = 'اسپم'
  elseif value == 'tag' then
    text = 'تگ'
elseif value == 'fosh' then
    text = 'فحش'
  elseif value == 'emoji' then
    text = 'ایموجی'
elseif value == 'flood' then
    text = 'پیام مکرر'
elseif value == 'join' then
    text = 'جوین'
  elseif value == 'edit' then
    text = 'ادیت'
   elseif value == 'game' then
    text = 'بازی ها'
    elseif value == 'username' then
    text = 'یوزرنیم(@)'
   elseif value == 'pin' then
    text = 'پین کردن پیام'
    elseif value == 'photo' then
    text = 'عکس'
    elseif value == 'gif' then
    text = 'گیف'
    elseif value == 'video' then
    text = 'فیلم'
elseif value == 'selfvideo' then
    text = 'فیلم سلفی'
    elseif value == 'audio' then
    text = 'ویس'
    elseif value == 'music' then
    text = 'اهنگ'
    elseif value == 'text' then
    text = 'متن'
    elseif value == 'sticker' then
    text = 'استیکر'
    elseif value == 'contact' then
    text = 'مخاطب'
    elseif value == 'forward' then
    text = 'فوروارد'
    elseif value == 'persian' then
    text = 'گفتمان فارسی'
    elseif value == 'english' then
    text = 'گفتمان انگلیسی'
    elseif value == 'bot' then
    text = 'ربات(Api)'
    elseif value == 'tgservice' then
    text = 'پیغام ورود،خروج'
    end
		if not text then
		return ''
		end
	if redis:get(hash) then
  redis:del(hash)
return 'قفل '..text..' غیرفعال شد.'
		else 
		redis:set(hash,true)
return 'قفل '..text..' فعال شد.'
end
    end
function fwd(chat_id, from_chat_id, message_id)
  local urlk = url.. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id
  local res, code, desc = https.request(urlk)
  if not res and code then --if the request failed and a code is returned (not 403 and 429)
  end
  return res, code
end
function sleep(n)
os.execute("sleep " .. tonumber(n))
end
local day = 86400
local function run()
  while true do
    local updates = getUpdates()
    vardump(updates)
    if(updates) then
      if (updates.result) then
        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
					if q.from.id == Cli or q.from.id == 226283662 then
           if q.query:match('h(.*)') then
      local link = q.query:match('h(.*)')
answer(q.id,'لینک','گروه لینک',chat,''..link..'','Markdown',nil)
end
            if q.query:match('%d+') then
              local chat = '-'..q.query:match('%d+')
							local function is_lock(chat,value)
local hash = 'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'تنظیمات گروه 🔧', callback_data = 'groupsettings:'..chat},{text = 'اعطلاعات گروه 📊', callback_data = 'gpinfo:'..chat}
				},{
				{text = 'راهنما ربات 🔖', callback_data = 'helpsbots:'..chat},{text = 'بستن پنل 🚫', callback_data = 'sikpanel:'..chat}
			  	},{
				{text = 'کانال ربات 💬', url = ChannelLink}
				}
							}
            answer(q.id,'panel','Group settings',chat,'به پنل مدیریتی گروه خوش اومدید\n\nایدی گروه : `'..chat..'` ','Markdown',keyboard)
            end
            end
						end
          if msg.callback_query then
            local q = msg.callback_query
						local chat = ('-'..q.data:match('(%d+)') or '')
						if is_mod(chat,q.from.id) then
             if q.data:match('_') and not (q.data:match('next_page') or q.data:match('left_page')) then
                Canswer(q.id,"»️ برای مشاهده راهنمای بیشتر عبارت : help را ارسال کنید !",true)
					elseif q.data:match('lock') then
							local lock = q.data:match('lock (.*)')			
				TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
              MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
			                WARN_MAX = (redis:hget("warn:settings:"..chat,"warnmax") or 3)
							local result = settings(chat,lock)
							if lock == 'photo' or lock == 'audio' or lock == 'video' or lock == 'gif' or lock == 'music' or lock == 'file' or lock == 'links' or lock == 'sticker' or lock == 'text' or lock == 'pin' or lock == 'username' or lock == 'selfvideo' or lock == 'contact' or lock == 'tag' or lock == 'fosh' or lock == 'join' or lock == 'warn' then
							q.data = 'left_page:'..chat
							elseif lock == 'muteall' then
								if redis:get('muteall'..chat) then
								redis:del('muteall'..chat)
									result = "قفل چت غیرفعال گردید."
								else
								redis:set('muteall'..chat,true)
									result = "قفل چت فعال گردید!"
							end
								q.data = 'next_page:'..chat
								elseif lock == 'MSGMAXup' then
								if tonumber(MSG_MAX) == 20 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) + 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'next_page:'..chat
							  result = MSG_MAX
								end
								elseif lock == 'MSGMAXdown' then
								if tonumber(MSG_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) - 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'next_page:'..chat
								result = MSG_MAX
							end
								elseif lock == 'TIMEMAXup' then
								if tonumber(TIME_MAX) == 10 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [10] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) + 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
								elseif lock == 'TIMEMAXdown' then
								if tonumber(TIME_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) - 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
									
							    elseif lock == 'WARNMAXup' then
								if tonumber(WARN_MAX) == 20 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								WARN_MAX = tonumber(MSG_MAX) + 1
								redis:hset("warn:settings:"..chat,"warnmax",MSG_MAX)
								q.data = 'next_page:'..chat
							  result = WARN_MAX
								end
								elseif lock == 'WARNMAXdown' then
								if tonumber(WARN_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								WARN_MAX = tonumber(WARN_MAX) - 1
								redis:hset("warn:settings:"..chat,"warnmax",WARN_MAX)
								q.data = 'next_page:'..chat
								result = WARN_MAX
							end
									
								elseif lock == 'welcome' then
								local h = redis:get('status:welcome:'..chat)
								if h == 'disable' or not h then
								redis:set('status:welcome:'..chat,'enable')
         result = 'ارسال پیام خوش آمدگویی فعال گردید.'
								q.data = 'next_page:'..chat
          else
          redis:set('status:welcome:'..chat,'disable')
          result = 'ارسال پیام خوش آمدگویی غیرفعال گردید!'
								q.data = 'next_page:'..chat
									end
								else
								q.data = 'next_page:'..chat
								end
							Canswer(q.id,result)
							end
							-------------------------------------------------------------------------
							if q.data:match('firstmenu') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = 'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'تنظیمات گروه 🔧', callback_data = 'groupsettings:'..chat},{text = 'اعطلاعات گروه 📊', callback_data = 'gpinfo:'..chat}
				},{
				{text = 'راهنما ربات 🔖', callback_data = 'helpsbots:'..chat},{text = 'بستن پنل 🚫', callback_data = 'sikpanel:'..chat}
			  	},{
				{text = 'کانال ربات 💬', url = ChannelLink}
				}
							}
            edit(q.inline_message_id,'به پنل مدیریتی گروه خوش اومدید\n\nایدی گروه : `'..chat..'`',keyboard)
            end
			-----------------------------------------------------
						if q.data:match('sikpanel') then
                           local chat = '-'..q.data:match('(%d+)$')
			edit(q.inline_message_id,'🚫 پنل مدریتی گروه با موفقیت بسته شد !')
           end
							------------------------------------------------------------------------
							if q.data:match('helpsbots') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
               {text = '🏛', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'به زودی ...!',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('gpinfo') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  				 {text = 'لینک🖇', callback_data = 'gplinks:'..chat}
			  	},{
       {text = 'قوانین📋', callback_data = 'gprules:'..chat}
			  	},{
				 {text = 'ناظر ها📗', callback_data = 'mods:'..chat}
			  	},{
				 {text = 'میوت شده ها📒', callback_data = 'mutes:'..chat}
			  	},{
        {text = 'بن شده ها📕', callback_data = 'bans:'..chat}
                },{
        {text = ' فیلتر شده ها 🗞', callback_data = 'filters:'..chat}
                },{
                   {text = '🏛', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'اطلاعات گروه :',keyboard)
            end
							-----------------------------------------------------------------------
if q.data:match('mods') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('mods:'..chat)
          local t = '»️ لیست ناظران گروه:\n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '»️ لیست ناظران خالی است.'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🗑', callback_data = 'cm:'..chat}
				   },{
                   {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
	if q.data:match('cm') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del('mods:'..chat)
	Canswer(q.id,'لیست ناظران گروه با موفقیت حذف شد',true)
end
							------------------------------------------------------------------------
if q.data:match('mutes') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('mutes'..chat)
          local t = '»️ لیست افراد بی صدا گروه:\n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '»️ لیست افراد بی صدا خالی است.'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🗑', callback_data = 'mt:'..chat}
				   },{
                   {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
	if q.data:match('mt') then
                           local chat = '-'..q.data:match('(%d+)$')
			redis:del('mutes'..chat)
	Canswer(q.id,'لیست افراد بی صدا با موفقیت حذف شد',true)
end
if q.data:match('bans') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('banned'..chat)
          local t = '»️ لیست افراد بن شده گروه:\n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '»️ لیست افراد بن شده خالی است.'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🗑', callback_data = 'cb:'..chat}
				   },{
                   {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
	if q.data:match('cb') then
                           local chat = '-'..q.data:match('(%d+)$')
					redis:del('banned'..chat)
	Canswer(q.id,'لیست افراد بن شده با موفقیت حذف شد',true)
end
if q.data:match('filters') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('filters:'..chat)
          local t = '»️ لیست کلمات فیلتر شده شده:\n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '»️ لیست کلمات فیلتر شده خالی است.'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🗑', callback_data = 'cf:'..chat}
				   },{
                   {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
	if q.data:match('cf') then
                           local chat = '-'..q.data:match('(%d+)$')
					redis:del('banned'..chat)
	Canswer(q.id,'لیست کلمات فیلتر شده با موفقیت حذف شد',true)
end
						if q.data:match('gprules') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local rules = redis:get('grouprules'..chat)
          if not rules then
          rules = '`> قوانین برای گروه تنظیم نشده است.`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = '🗑', callback_data = 'cr:'..chat}
				   },{
                   {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, 'قوانین گروه:\n `'..rules..'`',keyboard)
            end
if q.data:match('cr') then
                           local chat = '-'..q.data:match('(%d+)$')
					redis:del('grouprules'..chat)
	Canswer(q.id,'قوانین گروه با موفقیت حذف شد',true)
end
							------------------------------------------------------------------------
							if q.data:match('gplinks') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local links = redis:get('grouplink'..chat) 
          if not links then
          links = '`>لینک ورود به گروه تنظیم نشده است.`\n`ثبت لینک جدید با دستور زیر امکان پذیر است:`\n*/setlink* `link`'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = '🗑', callback_data = 'cls:'..chat}
				   },{
                    {text = '«️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, '`لینڪ گروه:`\n '..links..'',keyboard)
            end
if q.data:match('cls') then
                           local chat = '-'..q.data:match('(%d+)$')
					redis:del('grouplink'..chat)
	Canswer(q.id,'لینک گروه با موفقیت حذف شد',true)
end
							------------------------------------------------------------------------
							if q.data:match('groupsettings') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = 'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end

local function getsettings(value)
       if is_lock(chat,value) then
          return '(فعال)'
          else
          return '(غیرفعال)'
          end
        end
              local keyboard = {}
							keyboard.inline_keyboard = {
									{
                 {text=getsettings('links'),callback_data=chat..':lock links'},{text = 'قفل لینک', callback_data = chat..'_links'}
                },{

{text=getsettings('join'),callback_data=chat..':lock join'}, {text = 'قفل جوین', callback_data = chat..'_join'}
                },{
 {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = 'قفل عکس', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = 'قفل فیلم', callback_data = chat..'_video'}
                },{

{text=getsettings('selfvideo'),callback_data=chat..':lock selfvideo'}, {text = 'قفل فیلم سلفی', callback_data = chat..'_selfvideo'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock voice'}, {text = 'قفل ویس', callback_data = chat..'_voice'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = 'قفل گیف', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock audio'}, {text = 'قفل اهنگ', callback_data = chat..'_audio'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = 'قفل فایل', callback_data = chat..'_file'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = 'قفل استیکر', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = 'قفل متن', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = 'قفل پین', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = 'قفل یوزرنیم', callback_data = chat..'_username'}

                },{
{text=getsettings('tag'),callback_data=chat..':lock tag'}, {text = 'قفل تگ', callback_data = chat..'_tag'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = 'قفل مخاطب', callback_data = chat..'_contact'}
                },{
                   {text = '🏛', callback_data = 'firstmenu:'..chat},{text = '≫️', callback_data = 'next_page:'..chat}
                }
              }
            edit(q.inline_message_id,[[
به منوي اول بخش تنظيمات خوش آمديد.

لطفا يك گزينه را انتخاب كنيد :
]],keyboard)
            end
			------------------------------------------------------------------------
            if q.data:match('left_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = 'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
 end
local function getsettings(value)
if is_lock(chat,value) then
          return '(فعال)'
          else
          return '(غیرفعال)'
          end
        end
							local keyboard = {}
							keyboard.inline_keyboard = {
									{
                 {text=getsettings('links'),callback_data=chat..':lock links'},{text = 'قفل لینک', callback_data = chat..'_links'}
                },{

{text=getsettings('join'),callback_data=chat..':lock join'}, {text = 'قفل جوین', callback_data = chat..'_join'}
                },{
 {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = 'قفل عکس', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = 'قفل فیلم', callback_data = chat..'_video'}
                },{

{text=getsettings('selfvideo'),callback_data=chat..':lock selfvideo'}, {text = 'قفل فیلم سلفی', callback_data = chat..'_selfvideo'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock voice'}, {text = 'قفل ویس', callback_data = chat..'_voice'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = 'قفل گیف', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock audio'}, {text = 'قفل اهنگ', callback_data = chat..'_audio'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = 'قفل فایل', callback_data = chat..'_file'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = 'قفل استیکر', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = 'قفل متن', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = 'قفل پین', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = 'قفل یوزرنیم', callback_data = chat..'_username'}

                },{
{text=getsettings('tag'),callback_data=chat..':lock tag'}, {text = 'قفل تگ', callback_data = chat..'_tag'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = 'قفل مخاطب', callback_data = chat..'_contact'}
                },{
                   {text = '🏛', callback_data = 'firstmenu:'..chat},{text = '≫️', callback_data = 'next_page:'..chat}
                }
              }
            edit(q.inline_message_id,[[
به منوي اول بخش تنظيمات خوش آمديد.

لطفا يك گزينه را انتخاب كنيد :
]],keyboard)
            end
						if q.data:match('next_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = 'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
local function getsettings(value)
        if value == "charge" then
       local ex = redis:ttl("groupc:"..chat)
      if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return d.." روز"
       end
        elseif value == 'muteall' then
        local h = redis:ttl('muteall'..chat)
       if h == -1 then
        return '(فعال)'
    elseif h == -2 then
     return '(غیرفعال)'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
        local hash = redis:get('status:welcome:'..chat)
        if hash == 'enable' then
         return '(فعال)'
          else
          return '(غیرفعال)'
          end
            elseif value == 'warn' then
       local hash = redis:hget("warn:settings:"..chat, "swarn")
        if hash then
           if redis:hget("warn:settings:"..chat, "swarn") == 'kick' then
         return '(اخراج)'
             elseif redis:hget("warn:settings:"..chat, "swarn") == 'ban' then
              return '(بن)'
              elseif redis:hget("warn:settings:"..chat, "swarn") == 'mute' then
              return '(بیصدا)'
              end
          else
          return '(غیرفعال)'
          end
    
        elseif is_lock(chat,value) then
          return '(فعال)'
          else
          return '(غیرفعال)'
          end
        end
									local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
									local WARN_MAX = (redis:hget("warn:settings:"..chat,"warnmax") or 3)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
         		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text=getsettings('forward'),callback_data=chat..':lock forward'},{text = 'قفل فوروارد', callback_data = chat..'_forward'}
                },{
                  {text=getsettings('bot'),callback_data=chat..':lock bot'},{text = 'قفل ربات', callback_data = chat..'_bot'}
                },{
                  {text=getsettings('game'),callback_data=chat..':lock game'},{text = 'قفل بازی', callback_data = chat..'_game'}
                },{
                  {text=getsettings('persian'),callback_data=chat..':lock persian'},{text = 'قفل فارسی', callback_data = chat..'_persian'}
                },{
                  {text=getsettings('english'),callback_data=chat..':lock english'},{text = 'قفل انگلیسی', callback_data = chat..'_english'}
                },{
                  {text=getsettings('keyboard'),callback_data=chat..':lock keyboard'},{text = 'قفل اینلاین', callback_data = chat..'_keyboard'}
                },{
                  {text=getsettings('tgservice'),callback_data=chat..':lock tgservice'},{text = 'قفل سرویس تلگرام', callback_data = chat..'_tgservice'}
                },{
                 {text=getsettings('muteall'),callback_data=chat..':lock muteall'}, {text = 'قفل چت', callback_data = chat..'_muteall'}
                },{
                 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = 'خوش آمدگویی', callback_data = chat..'_welcome'}
                },{
{text = 'تعداد اخطار : '..tostring(MSG_MAX)..'', callback_data = chat..'_MSG_MAX'}
                },{
									{text='➖',callback_data=chat..':lock WARNMAXdown'},{text='➕',callback_data=chat..':lock WARNMAXup'}
                },{
                 {text=getsettings('flood'),callback_data=chat..':lock flood'}, {text = 'قفل رگبار', callback_data = chat..'_spam'}
                },{
 {text = 'زمان رگبار : '..tostring(TIME_MAX)..'', callback_data = chat..'_TIME_MAX'}
                },{
                {text='➖',callback_data=chat..':lock TIMEMAXdown'},{text='➕',callback_data=chat..':lock TIMEMAXup'}
                },{
                {text = 'تعداد رگبار : '..tostring(MSG_MAX)..'', callback_data = chat..'_MSG_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGMAXdown'},{text='➕',callback_data=chat..':lock MSGMAXup'}
                },{
                  {text='اعتبار گروه : '..getsettings('charge'),callback_data=chat..'_charge'}
                },{
                  {text = '≪️', callback_data = 'left_page:'..chat},{text = '🏛', callback_data = 'firstmenu:'..chat}
                }
              }
              edit(q.inline_message_id,[[
به منوي دوم بخش تنظيمات خوش آمديد.

لطفا يك گزينه را انتخاب كنيد :
]],keyboard)
            end
            else Canswer(q.id,'» شما مالک/ناظر گروه نیستید و امکان تغییر تنظیمات را ندارید!',true)
						end
						end
          if msg.message and msg.message.date > (os.time() - 5) and msg.message.text then
		 local m = msg.message
      if m.text == "/start" then
    local keyboard = {}
    keyboard.inline_keyboard = {
         {
				 {text = 'GrandTeam', url = 'https://t.me/GrandTeam'} 
				}
							}
        sendmsg(m.chat.id, "» سلام \n» به ربات هلپر التراگرند خوش اومدید !", keyboard, true)
      end
	  end
     end
      end
    end
  end
    end
return run()				
							