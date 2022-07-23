-- Twitch.tv Emotes plugin by Ali Digitali
-- Anyone reading this has permission to copy/modify PARTS of this script.

-- This script handles the following:
-- - string conversion of the used tags in the twitch.tv chat to a smaller tag
-- - triggering the images clientside

emotes = {
	{"CJPlz","-01"},
	{"DatSheffy","-02"},
	{"DogFace","-03"},
	{"JKanStyle","-04"},
	{"KevinTurtle","-05"},
	{"MrDestructoid","-06"},
	{"MVGame","-07"},
	{"OneHand","-08"},
	{"RalpherZ","-09"},
	{"Kappa","-10"},
	{"FrankerZ","-11"},
	{"BibleThump","-12"},
	{"FailFish","-13"},
	{"ItsBoshyTime","-14"},
	{"PogChamp","-15"},
	{"ResidentSleeper","-16"},
	{"SwiftRage","-17"},
	{"TriHard","-18"},
	{"Kreygasm","-19"},
	{"OpieOP","-20"},
	{"DansGame","-21"},
	{"BORT","-22"},
	{"BrainSlug","-23"}
	--{"newImage","-23"}
	}
	
function playerChat(text, messageType)		
	cancelEvent() --Cancel the message, the message will be output after string conversions
	
	local originalText = text
	
	-- string conversions so that the id for an emote can be hidden under the emote itself
	for index,item in ipairs(emotes) do
		text,item[3] = string.gsub(text,item[1],item[2])
	end
	-- text is now converted to shorter ID's
	local chat = removeColorCodes(getPlayerName(source)..":#FFFFFF "..text)
	-- chat is now a string with the text that will appear
	
	-- triggers the emotes (if found) to be displayed clientside
	for index,item in ipairs(emotes) do
		if item[3]>0 then
			triggerClientEvent("triggerChat",source,chat,item[1],item[2])
		end
	end
	
	for index,item in ipairs(emotes) do
		originalText,item[3] = string.gsub(originalText,item[1],"      ") -- 6 spaces = 18 pixels, -01 is also 18 pixels
	end
	
	if (messageType == 0) or (messageType == 3) then
		outputChatBox(getPlayerName(source)..":#FFFFFF "..originalText,root,255,255,255,true)
	elseif (messageType == 1) then
		outputChatBox("*"..removeColorCodes(getPlayerName(source).." "..originalText),root,255,0,255,false)
	end
end
addEventHandler("onPlayerChat", root, playerChat)

function removeColorCodes(str)
  return (string.gsub(str, "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]", ""))
end