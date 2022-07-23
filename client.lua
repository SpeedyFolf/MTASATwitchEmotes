-- Twitch.tv Emotes plugin by Ali Digitali
-- Anyone reading this has permission to copy/modify PARTS of this script.

-- This script handles the following:
-- - calculation of the (image) offsets
-- - displaying an image on top of a specific tag
-- - shifting images up when a new line of text appears in the chatbox


emotes = {} -- table for the pictures

-- triggered from serverside	
function showEmotes(originaltext,emote,emoteID)
	-- local scale = getChatboxLayout()["text_scale"]
	-- outputChatBox("The Chat Scale is " .. scale)
	-- local a = dxGetTextWidth("-01",scale,"arial")
	-- outputChatBox("Width: " .. a)
	
	local totaltextwidth = getImageOffsets(originaltext)
	local chatwidth = getChatboxLayout()["chat_width"]*317*scaleX
	local originalmultiplier = math.floor(totaltextwidth/chatwidth) -- howmany lines does the incomming text have

	local text,_ = string.gsub(originaltext,tostring(emoteID..".*"),"") -- find the first occurrence, remove everything after
	local width = getImageOffsets(text)
	
	local multiplier = math.floor(width/chatwidth) -- on which line does the emote occur	
	local width = width-multiplier*chatwidth -- adjust the width because of the word wrap to the next line
	table.insert(emotes,{emote,width,lines-(originalmultiplier-multiplier),false}) -- insert the emote into a table, include the width and the max line (it will appear on this line first)
	
	local _,index1 = string.gsub(originaltext,emoteID,emoteID) -- get the total amount of emotes, if multiple emotes are present, do this again
	if index1>1 then
		local text,index = string.gsub(originaltext,emoteID,"-00",1) -- replace the first emote it found with a syntax slightly different so it skips over it the next time
		showEmotes(text,emote,emoteID)
	end
end
addEvent("triggerChat",true)
addEventHandler("triggerChat",root,showEmotes)

function getImageOffsets(text) -- get the offset of the image
	lines = getChatboxLayout()["chat_lines"] -- get the amount of lines the chat has
	local chatboxscale = getChatboxLayout()["text_scale"]-- get the scale of the text
	local fontint = getChatboxLayout()["chat_font"]-- get the font of the chat text
	scaleX = getChatboxLayout()["chat_scale"][1]
	scaleY = getChatboxLayout()["chat_scale"][2]
		if fontint == 0 then
			font = "default"
		end
		if fontint == 1 then
			font = "clear"
		end
		if fontint == 2 then
			font = "default-bold"
		end
		if fontint == 3 then
			font = "arial"
		end
	fontheight = dxGetFontHeight(chatboxscale,font) -- get the height of the font, this is how high each line is
	local width = (dxGetTextWidth(text,chatboxscale,font)+chatxoffset)*scaleX -- calculate the width of the text + offset of the chatbox	
	return width
end

local screenWidth, screenHeight = guiGetScreenSize ( ) -- Get the screen resolution (width and height)
chatxoffset = screenWidth * 0.0145
chatyoffset = screenHeight * 0.0145
function createText ( )
	for index,item in ipairs(emotes) do -- for every emote
		local line = item[3]	-- get the line the emote is on
		local width = item[2]	-- get the width of the emote
		local height = (chatyoffset + (line-1)*fontheight)*scaleY	-- calculate the height
		if (item[3]<1) then 
			table.remove(emotes,index) -- remove the emote if it's at the top of the chat
		else
		dxDrawImage(width,height,22,22,tostring(item[1]..".png"),0,0,0,tocolor(255,255,255,255),true) -- and finally show the emote
		end
		
		-- --Debug: Draw lines at the spawnpoint of the image
		-- dxDrawLine(chatxoffset, height, getChatboxLayout()["chat_width"]*317, height,tocolor( 255, 0, 0, 255 ),3,false)
		-- dxDrawLine(width, 0, width,height*2,tocolor( 255, 0, 0, 255 ),3,false)
		-- --Chatbox outline:
		-- local chatwidth = getChatboxLayout()["chat_width"]*317*scaleX
		-- dxDrawLine(chatxoffset,chatyoffset,chatxoffset,500,tocolor( 255, 0, 0, 255 ),1,false)
		-- dxDrawLine(chatxoffset,chatyoffset,chatxoffset+chatwidth,chatyoffset,tocolor( 255, 0, 0, 255 ),1,false)
		-- dxDrawLine(chatxoffset+chatwidth,chatyoffset,chatxoffset+chatwidth,500,tocolor( 255, 0, 0, 255 ),1,false)
	end
end

--turn emotes on/off by using /emote
function emotesOnOff()
	if emotesVisible then
		removeEventHandler ( "onClientRender", root, createText )
		emotesVisible = false
	else
		addEventHandler ( "onClientRender", root, createText )
		emotesVisible = true
	end
end

function HandleTheRendering ( )
	addEventHandler ( "onClientRender", root, createText ) -- keep the text visible with onClientRender.
	emotesVisible = true
	addCommandHandler ("emotes", emotesOnOff )
end
addEventHandler ( "onClientResourceStart", resourceRoot, HandleTheRendering )

-- FUNCTION TO SHIFT THE EMOTES UP WHEN NEW THINGS ARE INPUT TO THE CHATBOX
function onClientChatMessageHandler(text)
	local width = getImageOffsets(text)
	local chatwidth = getChatboxLayout()["chat_width"]*317*scaleX
	local multiplier = math.floor(width/chatwidth)+1 -- if the text fits on one line, multiplier is 1. if there's text that takes up multiple lines extra shifts are needed.
	
	for index,item in ipairs(emotes) do
		if item[4] then -- check to make sure that the message containing the emote itself doesn't cause a shift up
			item[3] = item[3]-1*multiplier -- move it up row(s) in the chat
		end
		item[4]= true -- set the check to true for the next time
	end
end
addEventHandler("onClientChatMessage", getRootElement(), onClientChatMessageHandler)