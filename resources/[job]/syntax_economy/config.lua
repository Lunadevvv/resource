Config = {}

Config.Framework = {
	Client = 'esx:getSharedObject',
	Server = 'esx:getSharedObject'
}
Config.CheckKeyWithCommand 	= true;										-- เปิดใช้งาน การเช็คราคาตลาดด้วย คำสั่ง หรือ การกดแบบใหม่ที่ไม่ใช้ลูป
Config.CheckKeysWithLoop 	= true;										-- เปิดใช้งาน การเช็คราคาตลาดด้วยการกดปุ่มแบบลูป
Config.KeyLoops 			= 57										-- ปุ่มในการกดเช็คราคาตลาด Default: 56 (F9)
Config.EconomyKeys			= "F9"										-- ปุ่มกด ดูราคา Economy
Config.itemImage			= "nui://ox_inventory/web/images/"	-- URL Inventory Image - URL รูปกระเป๋า
Config.Color            	= 5763719;      							-- หาได้จาก https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812xItem
Config.InDeCress        	= 5;										-- จำนวน เปอร์เซ็นต์ ที่ ลด แนะนำอย่าตั้งเกิน 10 เปอร์เซ็นต์
Config.DrawDistance 		= 5.0										-- ระยะที่ให้เห็น วง
Config.EconomyUpdate    	= 10											-- ระยะเวลาที่ใช้ในการ Update Economy แต่ละครั้ง
Config.Text 	        	= '~g~[ ~s~E~g~ ]~s~ nói chuyện' 		 -- #ข้อความที่ NPC
Config.DisCount         	= 10;										-- จะลดราคา ของ เมื่อ ถึง จำนวนที่ตั้งไว้
Config.RepriceOnCount 		= true;									    -- จะรีราคาของเมื่อขายถึงจำนวนที่ตั้งไว้ หรือไม่ 
Config['Webhooks'] 			= {
	["URL"]					= "WEBHOOKS",								-- Webhooks Discord
	["Enable"] 				= false,									-- เปิดการใช้งาน Webhooks แยก
	["CustomWebhook"] 		= function(playerId, xPlayer, ItemName, ItemCount, AllPrice, PricePerCount)
		local message 		= ("**รายละเอียด**:\n```%s ได้ทำการขาย %s จำนวน %s ได้เงินทั้งหมด %s บาท ( %s฿/ชิ้น )```"):format(GetPlayerName(playerId), ItemName, ItemCount, AllPrice, PricePerCount)
		TriggerEvent('azael_dc-serverlogs:sendToDiscord', 'economy', message, playerId, '^1')
	end
}

NotifyChane = function()
    TriggerClientEvent('chat:addMessage', -1, { 
        args = { 
            '^1ECONOMY', 'Giá thị trường đã thay đổi.'
        }
    })
end

Config['Translate'] 		= {
	['SellItems'] 			= 'Đã bán được %s$';
	['NoHaveItems'] 		= 'Không có <span style="color:#ea5f5f;"> %s </span>';
}

NotifySV = function(text, source)
	TriggerClientEvent("notify:Alert", source, "Hệ thống", text, 3000, 'success')
end

NotifyCL = function(text)
	exports.notify:Alert("Hệ thống", text, '3000', 'error')
end

Config.Zones = {
	Economy = {
		coords = vector3(891.2999877929688, -44.81999969482422, 78.77999877929688),	-- พิกัดของตลาด # vecotr3 Only
		nameH = 1.0, 								-- ปรับให้ข้อความเลื่อนขึ้น หรือ ลง *ถ้าอยากให้ลง ใส่ให้จำนวนติดลบ
        items = {									-- ลิสต์ของไอเทมที่ขาย
			"silver",
			"copper",
			"gold",
			"diamond",
			"gosua",
			"gosu",
			"gogu",
			"gocamlai",
			"tuna",
			"salmon",
			"trout",
			"anchovy",
		},
		NPC = {
			Model = "cs_bankman",					-- Model ของ NPC # จะใส่เป็น mp_m_freemode_01 หรือ mp_f_freemode_01 ก็ได้
			heading = 60.24,						-- จะให้ NPC หันไปทางไหน
			Animation = { -- ใส่ท่าทางให้ NPC
				Scenario = false,
				AnimationDirect = "anim@amb@nightclub@peds@",
				AnimationScene = "rcmme_amanda1_stand_loop_cop",
			},
		},
		Marker = {
			type = 29,				-- # ชนิดของ Marker
			up = 1.1,				-- # ให้ Marker เลื่อนขึ้นแค่ไหน อยากให้ลง ใส่ลบด้านห้นาตัวเลข
			dirX = 0,				-- # Don't Touch
			dirY = 0,				-- # Don't Touch
			dirZ = 0,				-- # Don't Touch
			rotX = 0,				-- # Don't Touch
			rotY = 0,				-- # Don't Touch
			rotZ = 0,				-- # Don't Touch
			scaleX = 0.40,			-- # ขนาดของ Marker
			scaleY = 0.40,			-- # ขนาดของ Marker
			scaleZ = 0.40,			-- # ขนาดของ Marker
			red = 170,				-- # สีของ Marker สีแดง
			green = 224,			-- # สีของ Marker สีเขียว
			blue = 105,				-- # สีของ Marker สีน้ำเงิน
			alpha = 1000,			-- # ความใส่ของสี 
			bobUpAndDown = 0,		-- # Animation ทำให้ขึ้นลง
			faceCamera = 0,			-- # ตามกล้อง
			p19 = 0,				-- # Don't Touch
			rotate = 1,				-- # ให้ Marker หมุน
			textureDict = 0,		-- # ไม่เคยใช้
			textureName = 0,		-- # ไม่เคยใช้
			drawOnEnts = 0,			-- # ไม่เคยใช้
		},
		Blips = {
			name = 'Seller',
			color = 2,
			sprite = 500,
			radius = 100.0,
		},
	},
}

Config.Items = {
    ["silver"] = {            -- กล้วย
		name = "Bạc",
        randomPrice = {15,30} 
    },	
    ["copper"] = {           -- ทุเรียน
		name = "Đồng",
        randomPrice = {18,33}
    },		
    ["gold"] = {           -- ทุเรียน
		name = "Vàng",
        randomPrice = {18,33}
    },		
    ["diamond"] = {           -- ทุเรียน
		name = "Kim cương",
        randomPrice = {18,33}
    },		
    ["gosua"] = {           -- ทุเรียน
		name = "Gỗ Sưa",
        randomPrice = {18,33}
    },		
    ["gosu"] = {           -- ทุเรียน
		name = "Gỗ Sụ",
        randomPrice = {18,33}
    },		
    ["gogu"] = {           -- ทุเรียน
		name = "Gỗ Gụ",
        randomPrice = {18,33}
    },		
    ["gocamlai"] = {           -- ทุเรียน
		name = "Gỗ Cẩm Lai",
        randomPrice = {18,33}
    },		
    ["tuna"] = {           -- ทุเรียน
		name = "Đồng",
        randomPrice = {18,33}
    },		
    ["salmon"] = {           -- ทุเรียน
		name = "Đồng",
        randomPrice = {18,33}
    },		
    ["trout"] = {           -- ทุเรียน
		name = "Đồng",
        randomPrice = {18,33}
    },		
    ["anchovy"] = {           -- ทุเรียน
		name = "Đồng",
        randomPrice = {18,33}
    },	
}