-- To Set This Up visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686
local players = 0
RegisterNetEvent('luna:getplayers')
AddEventHandler('luna:getplayers', function(total)
    players = total
end)

CreateThread(function()
	while true do
		TriggerServerEvent('luna:getplayers')
		Wait(30 * 1000)
	end
end)

CreateThread(function()
    while true do
        -- This is the Application ID (Replace this with you own)
	SetDiscordAppId(964810347670278185)

        -- Here you will have to put the image name for the "large" icon.
	SetDiscordRichPresenceAsset('mylogo')
        
        -- (11-11-2018) New Natives:

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Nhìn giề! Vô đây mà nhìn')
       
        -- Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('mylogo')

        -- Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('This is a small icon with text')

        SetRichPresence(players * 2 .. "/1024 - [ID: " .. GetPlayerServerId(PlayerId()) .. "]")

        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/fC8eRjazVj")
        SetDiscordRichPresenceAction(1, "Chơi game", "https://cfx.re/join/7elk6r")

        -- It updates every minute just in case.
	Wait(60000)
    end
end)

