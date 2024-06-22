AK4Y = {}

AK4Y.Framework = "esx" -- qb / oldqb | qb = export system | oldqb = triggerevent system
AK4Y.Mysql = "oxmysql" -- Check fxmanifest.lua when you change it! | ghmattimysql / oxmysql / mysql-async
AK4Y.UseTebexForPremiumCodes = false
AK4Y.RequiredXpForNextLevel = 1000
AK4Y.BPEndDate = {day = 23, month = 11, year = 2023} -- Make sure your server is dated correctly
AK4Y.DailyTasksResetPeriod = 3 -- DAY
AK4Y.DefaultGarage = 'impoundlot' -- Garage name where the vehicle will be sent after get reward

AK4Y.Language = {
    ["openSpamProtectNotif"] = "Bạn không thể mở menu ngay bây giờ, vui lòng đợi một chút.",
    ["title1"] = "RABBIT CAVE",
    ["title2"] = "BATTLE PASS",
    ["collectedText"] = "Nhận phần thưởng",
    ["dailyText"] = "NHIỆM VỤ CÀY EXP",
    ["remainingText"] = "Còn lại",
    ["dayText"] = "ngày",
    ["accountTypeText"] = "TÀI KHOẢNG CỦA BẠN :",
    ["premiumBuyButtonText"] = "MUA PREMIUM PASS",
    ["redeemInfoText"] = "Bạn có thể kích hoạt nó bằng cách nhập mã CODE PREMIUM PASS của bạn ở đây.",
    ["premiumCodeTitle1"] = "NHẬP MÃ",
    ["premiumCodeTitle2"] = "PREMIUM",
    ["premiumCodeTitle3"] = "CODE:",
    ["acceptButtonText"] = "XÁC NHẬN",
    ["premiumTasksText1"] = "NHIỆM VỤ",
    ["premiumTasksText2"] = "ỔN ĐỊNH",
    ["upgradeAccountCongratTitle"] = "CHÚC MỪNG!",
    ["upgradeAccountText"] = "Tài khoản của bạn đã được nâng cấp lên PREMIUM",
    ["piece"] = "",
    ["moneySymbol"] = "$",
}

-- STANDART TASKS
AK4Y.BattlePassTasks = {
    {taskId = 1, requiredcount = 2, rewardXP = 300, taskTitle = "Hãy nhắn lên câu 'rabbitcavemaidinh' trong kênh chat", taskDescription = "."},
    {taskId = 2, requiredcount = 100, rewardXP = 200, taskTitle = "Đi làm công việc đào đá", taskDescription = "."},
    {taskId = 3, requiredcount = 5, rewardXP = 300, taskTitle = "Đi lau nhà 5 lần", taskDescription = "."},
    {taskId = 4, requiredcount = 50, rewardXP = 400, taskTitle = "Đi câu 50 con cá ở CÂU CÁ VERSION 2", taskDescription = "."},
    {taskId = 5, requiredcount = 10, rewardXP = 150, taskTitle = "Ra tạp hoá mua 10 món đồ", taskDescription = "."},
    {taskId = 6, requiredcount = 5, rewardXP = 250, taskTitle = "Chế tạo vật phẩm 5 lần", taskDescription = "."},
    -- {taskId = 7, requiredcount = 20, rewardXP = 700, taskTitle = "Do sports on the GYM", taskDescription = "."},
    -- {taskId = 8, requiredcount = 10, rewardXP = 800, taskTitle = "Hunt Deer", taskDescription = "."},
}

-- STABLE TASKS
AK4Y.DailyPremiumTasks = {
    {taskId = 1, requiredcount = 5, rewardXP = 2000, taskTitle = "CƯỚP NHÀ BANK 5 LẦN", taskDescription = "."},
    {taskId = 2, requiredcount = 3, rewardXP = 1000, taskTitle = "CƯỚP TẠP HOÁ 3 LẦN", taskDescription = "."},
}

-- BATTLE PASS PRIZES
AK4Y.BattlePassItems = {
    {
        taskId = 1,
        requiredLevel = 1,                                           -- type = item, money, weapon, vehicle | if your weapons are item. you should type item.
        rewards = {
            standart = {                                             -- unique = true : gives items one by one
                itemLabel = "sh150", itemName = "sh150", type = "vehicle", count = 1, unique = false, image = "./images/sh150.png"
            },
            premium = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 1000000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
    {
        taskId = 2,
        requiredLevel = 2,
        rewards = {
            standart = {
                itemLabel = "Water", itemName = "water", type = "money", count = 10, unique = false, image = "./images/water.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
    {
        taskId = 3,
        requiredLevel = 3,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
    {
        taskId = 4,
        requiredLevel = 4,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
    {
        taskId = 5,
        requiredLevel = 5,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
    {
        taskId = 6,
        requiredLevel = 6,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },

    {
        taskId = 7,
        requiredLevel = 7,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },

    {
        taskId = 8,
        requiredLevel = 8,
        rewards = {
            standart = {
                itemLabel = "Money", itemName = "cash", type = "money", count = 10, unique = false, image = "./images/moneyBag.png"
            },
            premium = {
                itemLabel = "Premium Money", itemName = "cash", type = "money", count = 1000, unique = false, image = "./images/moneyBag.png"
            }
        }
    },
}