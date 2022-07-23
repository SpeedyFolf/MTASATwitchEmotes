# MTASATwitchEmotes
## What does it do?
The emotes will show up in the chat when you type their name (just as on twitch.tv).
## What emotes are available?
All of them except a majority of channel subscriber/follower emotes, that would be a ton of work.
## How do I add it to my server?
1. Click the green code button, click download ZIP, then place the ZIP file in `C:\Program Files (x86)\MTA San Andreas 1.5\server\mods\deathmatch\resources`.
2. Navigate to `C:\Program Files (x86)\MTA San Andreas 1.5\server\mods\deathmatch\mtaserver.conf` and add `<resource src="TwitchEmotes" startup="1" protected="0" />` to the resource list at the bottom.
## Note for Server
Any chat from players gets cancelled and then output manually. If you have any other resources running that also do this (such as play) chat will be output twice.
## Note for Client
Emotes can be turned on or off with /emotes. The emotes may not be displayed correctly if you are playing at a low resolution. The emotes are displayed best on the transparent chat preset: Settings -> Interface -> Load Transparent Preset.
### Credits
Ali Digitali, SpeedyFolf, Twitch