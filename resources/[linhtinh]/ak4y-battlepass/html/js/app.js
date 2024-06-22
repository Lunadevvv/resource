var mdrp = false;

var battlePassItems = [];
var bpBottomTasks = [];
var bpDailyTasks = [];
var maxLevel = 1000;
var inRedeemArea = false;
var neededEXP = 1000;
var currentLevel = 0;
var currentXP = 0;
var userPremium = false;
var collectedText = "Collected";
var myRewardsCache = [];
var dolarSymbol = "$";
var piece = " pc.";

function updatecounters() {
    if (currentXP >= neededEXP) {
        currentLevel += Math.floor(currentXP / neededEXP);
        currentXP = currentXP % neededEXP;
    }
    setTimeout(() => {
        currentXP = currentLevel > maxLevel ? neededEXP : currentXP;
        currentLevel = currentLevel > maxLevel ? maxLevel : currentLevel;
        document.getElementById("myCurrentLevel").innerHTML = currentLevel;
        $(".levelRectFill").css("width", (currentXP / neededEXP) * 100 + "%");
        $(".currentXPText").html(currentXP);
    }, 100);
}

function giveExp(number) {
    currentLevel = 0;
    currentXP = 0;
    currentXP += number;
    updatecounters();
}

function giveJustExp(number) {
    currentXP += number;
    updatecounters();
}

function setPremiumAreas(data) {
    userPremium = data;
    var accTypeText = document.getElementById("accTypeID");
    var profilAreaType = document.getElementById("profilAreaTYPE");
    if (data) {
        accTypeText.className += " premiumActive";
        profilAreaType.className += " premiumProfilInfos";
        $(".accountTypeReal").html("PREMIUM");
        $(".battlePassNotPremiumItemBlur").hide();
    } else {
        accTypeText.className = "accountTypeReal";
        profilAreaType.className = "profilInfos";
        $(".accountTypeReal").html("STANDART");
        $(".battlePassNotPremiumItemBlur").show();
    }
}

window.addEventListener("message", event => {
    if (event.data.type === "openUi") {
        giveExp(event.data.currentXP);
        setPremiumAreas(event.data.userPremium);
        battlePassItems = event.data.bpItems;
        bpBottomTasks = event.data.bpBottomTask;
        bpDailyTasks = event.data.bpDailyPremiumTasks;
        maxLevel = battlePassItems.length;
        $(".maxLevel").html(maxLevel);
        setTimeout(() => {
			myRewardsCache = event.data.rewards;
            setBattlePassItems(battlePassItems, event.data.rewards);
            setBottomTasks(bpBottomTasks, event.data.standartTasks);
            setPremiumTasks(bpDailyTasks, event.data.premiumTasks);
        }, 100);
        $(".generalContainer").fadeIn(200);
        $("#endDate").html(event.data.bpResetTime);
        $("#playerName").html(event.data.firstName);
        $("#playerSurName").html(event.data.lastName);
        var myDate = new Date(event.data.bpDailyResetTime);
        myConvertedDate = myDate.toLocaleString();
        mySexyDate = myConvertedDate.split(",")[0];
        if (mySexyDate != "Invalid Date") {
            $(".resetDailyTaskText").html(mySexyDate);
        }
    } else if (event.data.type === "firstLoading") {
        neededEXP = event.data.neededEXP;
        collectedText = event.data.htmlLanguage.collectedText;
        dolarSymbol = event.data.htmlLanguage.moneySymbol;
        piece = event.data.htmlLanguage.piece;
        $("#title-1").html(event.data.htmlLanguage.title1);
        $("#title-2").html(event.data.htmlLanguage.title2);
        $(".endTimeText").html(event.data.htmlLanguage.remainingText);
        $("#dayText").html(event.data.htmlLanguage.dayText);
        $(".textAccountType").html(event.data.htmlLanguage.accountTypeText);
        $(".buyPremiumButton").html(event.data.htmlLanguage.premiumBuyButtonText);
        $(".redeemInfoText").html(event.data.htmlLanguage.redeemInfoText);
        $("#premiumCodeTitle1").html(event.data.htmlLanguage.premiumCodeTitle1);
        $("#premiumCodeTitle2").html(event.data.htmlLanguage.premiumCodeTitle2);
        $("#premiumCodeTitle3").html(event.data.htmlLanguage.premiumCodeTitle3);
        $("#premiumTasksText1").html(event.data.htmlLanguage.premiumTasksText1);
        $("#premiumTasksText2").html(event.data.htmlLanguage.premiumTasksText2);
        $(".bottomTaskText").html(event.data.htmlLanguage.dailyText);
        $(".acceptButtonRedeemCode").html(event.data.htmlLanguage.acceptButtonText);
        $(".upgradeTopArea").html(event.data.htmlLanguage.upgradeAccountCongratTitle);
        $(".upgradeNotifMiddle").html(event.data.htmlLanguage.upgradeAccountText);
        $(".neededXP").html(neededEXP + " XP");
    } else if (event.data.type === "addEXP") {
        giveJustExp(event.data.exp);
		setBattlePassItems(battlePassItems, myRewardsCache);
    }
});

function setBattlePassItems(data, playerDetails) {
    $(".BPItemArea").empty();
    var recentEvent = $(".BPItemArea").html();
    for (let i = 0; i < data.length; i++) {
        const element = data[i];
        var standartStringify = JSON.stringify(element.rewards.standart);
        var premiumStringify = JSON.stringify(element.rewards.premium);
        var standartItemDetails = JSON.parse(standartStringify);
        var premiumItemDetails = JSON.parse(premiumStringify);
        var standartItemCount = standartItemDetails.type === "money" ? "$" + standartItemDetails.count : standartItemDetails.count + " pc.";
        var premiumItemCount = premiumItemDetails.type === "money" ? "$" + premiumItemDetails.count : premiumItemDetails.count + " pc.";
        var levelIsOkayFORLevelTextSTANDART = "";
        var levelIsOkayForStandartBoxSTANDART = "";
        var levelIsOkayForCountSTANDART = "";
        var levelIsOkayForStandartBoxPREMIUM = "";
        var levelIsOkayForCountPREMIUM = "";
        var addClass = "";
        if (element.requiredLevel <= currentLevel) {
            levelIsOkayFORLevelTextSTANDART = "bpItemLevelOK";
            levelIsOkayForStandartBoxSTANDART = "levelOkayStandart";
            levelIsOkayForCountSTANDART = "BPPriceStandartOK";
            levelIsOkayForStandartBoxPREMIUM = "levelOkayPremium";
            levelIsOkayForCountPREMIUM = "BPPricePremiumOK";
            addClass = " canTake";
        }
        var playerDetRewGeneral = JSON.parse(playerDetails)[i];
        var currentStandartReward = playerDetRewGeneral.rewards.standart;
        var currentPremiumReward = playerDetRewGeneral.rewards.premium;
        // console.log(JSON.stringify(standartItemDetails), typeof JSON.stringify(standartItemDetails));
        if (!currentStandartReward.taken && !currentPremiumReward.taken) {
            recentEvent =
                recentEvent +
                `
            <div class="bpLevelItem">
                <div class="BPItemLevelArea">
                    <div class="bplevelrect"></div>
                    <div class="bpItemLevel" id=${levelIsOkayFORLevelTextSTANDART}>${element.requiredLevel} LVL</div>
                    <div class="bplevelrect"></div>
                </div>
                <div class="bpItemRewardBoxes">
    
                    <div class="bpItemBoxStandart${addClass}" id=${levelIsOkayForStandartBoxSTANDART} data-taskId = "${
                    element.taskId
                }" data-reqLevel = "${element.requiredLevel}" data-rewardDetails = '${JSON.stringify(standartItemDetails)}'>
                        <div class="BPItemItemName">${standartItemDetails.itemLabel}</div>
                        <div class="BPItemImageSection">
                            <img src=${standartItemDetails.image} alt="" />
                        </div>
                        <div class="BPItemPrice" id=${levelIsOkayForCountSTANDART}>${standartItemCount}</div>
                    </div>

                    <div class="bpItemBoxPremium${addClass}" id=${levelIsOkayForStandartBoxPREMIUM} data-taskId = "${
                    element.taskId
                }" data-reqLevel = "${element.requiredLevel}" data-rewardDetails = '${JSON.stringify(premiumItemDetails)}'>
                        <div class="BPItemItemNamePremium">${premiumItemDetails.itemLabel}</div>
                        <div class="BPItemImageSectionPremium">
                            <img src=${premiumItemDetails.image} alt="" />
                        </div>
                        <div class="BPItemPricePremium" id=${levelIsOkayForCountPREMIUM}>${premiumItemCount}</div>
                    </div>

                </div>
            </div>
            `;
        } else if (currentStandartReward.taken && !currentPremiumReward.taken) {
            recentEvent =
                recentEvent +
                `
            <div class="bpLevelItem">
                <div class="BPItemLevelArea">
                    <div class="bplevelrect"></div>
                    <div class="bpItemLevel" id=${levelIsOkayFORLevelTextSTANDART}>${element.requiredLevel} LVL</div>
                    <div class="bplevelrect"></div>
                </div>
                <div class="bpItemRewardBoxes">
            
                    <div class="bpItemBoxStandart" id=${levelIsOkayForStandartBoxSTANDART}>
                        <div class="itemCollectedTextStandart">${collectedText}</div>
                    </div>

                    <div class="bpItemBoxPremium${addClass}" id=${levelIsOkayForStandartBoxPREMIUM} data-taskId = "${
                    element.taskId
                }" data-reqLevel = "${element.requiredLevel}" data-rewardDetails = '${JSON.stringify(premiumItemDetails)}'>
                        <div class="BPItemItemNamePremium">${premiumItemDetails.itemLabel}</div>
                        <div class="BPItemImageSectionPremium">
                            <img src=${premiumItemDetails.image} alt="" />
                        </div>
                        <div class="BPItemPricePremium" id=${levelIsOkayForCountPREMIUM}>${premiumItemCount}</div>
                    </div>

                </div>
            </div>
        `;
        } else if (!currentStandartReward.taken && currentPremiumReward.taken) {
            recentEvent =
                recentEvent +
                `
            <div class="bpLevelItem">
                <div class="BPItemLevelArea">
                    <div class="bplevelrect"></div>
                    <div class="bpItemLevel" id=${levelIsOkayFORLevelTextSTANDART}>${element.requiredLevel} LVL</div>
                    <div class="bplevelrect"></div>
                </div>
                <div class="bpItemRewardBoxes">
            
                    <div class="bpItemBoxStandart${addClass}" id=${levelIsOkayForStandartBoxSTANDART} data-taskId = "${
                    element.taskId
                }" data-reqLevel = "${element.requiredLevel}" data-rewardDetails = '${JSON.stringify(standartItemDetails)}'>
                        <div class="BPItemItemName">${standartItemDetails.itemLabel}</div>
                        <div class="BPItemImageSection">
                            <img src=${standartItemDetails.image} alt="" />
                        </div>
                        <div class="BPItemPrice" id=${levelIsOkayForCountSTANDART}>${standartItemCount}</div>
                    </div>

                    <div class="bpItemBoxPremium" id=${levelIsOkayForStandartBoxPREMIUM}>                
                        <div class="itemCollectedTextPremiumx">${collectedText}</div>
                    </div>

                </div>
            </div>
        `;
        } else if (currentStandartReward.taken && currentPremiumReward.taken) {
            recentEvent =
                recentEvent +
                `
            <div class="bpLevelItem">
                <div class="BPItemLevelArea">
                    <div class="bplevelrect"></div>
                    <div class="bpItemLevel" id=${levelIsOkayFORLevelTextSTANDART}>${element.requiredLevel} LVL</div>
                    <div class="bplevelrect"></div>
                </div>
                <div class="bpItemRewardBoxes">
            
                    <div class="bpItemBoxStandart" id=${levelIsOkayForStandartBoxSTANDART}>
                        <div class="itemCollectedTextStandart">${collectedText}</div>
                    </div>

                    <div class="bpItemBoxPremium" id=${levelIsOkayForStandartBoxPREMIUM}>                
                        <div class="itemCollectedTextPremiumx">${collectedText}</div>
                    </div>

                </div>
            </div>
        `;
        }
    }
    $(".BPItemArea").html(recentEvent);
}

function setBottomTasks(data, userDetails) {
    $(".bottomTaskItemList").empty();
    for (let i = 0; i < data.length; i++) {
        const element = data[i];
        var userDet = JSON.parse(userDetails);
        if (typeof userDet[i] !== "undefined") {
            if (!userDet[i].taken && userDet[i].hasCount >= element.requiredcount) {
                $.post("https://ak4y-battlepass/standartTaskDone", JSON.stringify({ taskId: element.taskId }));
            }
            var deneme = `
                <div class="bottomTaskItem">
                    <div class="inBottomFlex">
                        <div class="bottomTaskLeftArea">
                            <div class="bottomTaskLeftTop">
                                <div class="bottomTaskId">#${i + 1}</div>
                                <div class="bottomTaskName">${element.taskTitle}</div>
                            </div>

                            <div class="bottomItemDescArea">
                                ${element.taskDescription}
                            </div>
                        </div>

                        <div class="bottomTaskRightArea">
                            <div class="bottomRadialArea">
                                <div id="taskBarProgressID-${i + 1}"></div>
                            </div>
                            <div class="bottomReward">
                                Reward :
                                <span>${element.rewardXP}</span>
                                <p>EXP</p>
                            </div>
                        </div>
                    </div>
                </div>
                `;
            $(".bottomTaskItemList").append(deneme);
            progressBarCreate(i + 1);
            var myCount = userDet[i].hasCount > element.requiredcount ? element.requiredcount : userDet[i].hasCount;
            changeProgressBar(i + 1, myCount / element.requiredcount, userDet[i].hasCount + "/" + element.requiredcount);
        }
    }
}

function setPremiumTasks(data, userDetails) {
    $(".premiumTasks").empty();
    for (let i = 0; i < data.length; i++) {
        const element = data[i];
        var userDet = JSON.parse(userDetails);
        if (typeof userDet[i] !== "undefined") {
            if (!userDet[i].taken && userDet[i].hasCount >= element.requiredcount) {
                $.post("https://ak4y-battlepass/premiumTaskDone", JSON.stringify({ taskId: element.taskId }));
            }
            var progID = i + 9;
            var deneme = `
                <div class="premiumTaskItem">
                    <div class="premiumFlexArea">
                        <div class="premiumTaskLeftArea">
                            <div class="premiumLeftTaskInfoArea">
                            <span>#${i + 1}</span>
                                ${element.taskTitle}
                            </div>
                            <div class="premiumLeftTaskDescription">
                                ${element.taskDescription}
                            </div>
                        </div>
                        <div class="premiumTaskRightArea">
                            <div id="taskBarProgressID-${progID}"></div>
                            <div class="rewardPremiumText">
                                Reward:
                                <span>${element.rewardXP}</span>
                                <p>EXP</p>
                            </div>
                        </div>
                    </div>
                </div>
                `;
            $(".premiumTasks").append(deneme);
            premiumProgressCreate(progID);
            var myCount = userDet[i].hasCount > element.requiredcount ? element.requiredcount : userDet[i].hasCount;
            premiumProgressChange(progID, myCount / element.requiredcount, userDet[i].hasCount + "/" + element.requiredcount);
        }
    }
}

$(document).on("keydown", function () {
    switch (event.keyCode) {
        case 27: // ESC
            if (inRedeemArea) {
                inRedeemArea = false;
                $(".redeemCodeGeneral").hide();
            } else {
                $.post("https://ak4y-battlepass/closeMenu", JSON.stringify());
                $(".generalContainer").fadeOut(200);
                setTimeout(() => {
                    $(".generalContainer").hide();
                }, 200);
            }
            break;
    }
});

var elements = document.getElementById("scollItemList");
var elements2 = document.getElementById("scollBlur");
elements.addEventListener("wheel", event => {
    event.preventDefault();
    elements.scrollBy({
        left: event.deltaY < 0 ? -40 : 40,
    });
});
elements2.addEventListener("wheel", event => {
    event.preventDefault();
    elements.scrollBy({
        left: event.deltaY < 0 ? -40 : 40,
    });
});

$(document).on("click", ".buyPremiumButton", function () {
    inRedeemArea = true;
    $(".redeemCodeGeneral").show();
});

$(document).on("click", ".bpItemBoxStandart.canTake", function () {
    let myActuallyDiv = this;
    let rewDetailsString = $(this).attr("data-rewardDetails");
    let rewReqLevel = $(this).attr("data-reqLevel");
    let rewTaskId = $(this).attr("data-taskId");
    let detailParse = JSON.parse(rewDetailsString);
    myActuallyDiv.className = "bpItemBoxStandart";

    $.post(
        "https://ak4y-battlePass/getStandartReward",
        JSON.stringify({
            itemDetails: detailParse,
            reqLevel: rewReqLevel,
            reqTaskId: rewTaskId,
        }),
        function (data) {
            if (data) {
                collectRewardNotify(detailParse);
                $(myActuallyDiv).empty();
                myActuallyDiv.innerHTML = `           
                <div class="itemCollectedTextStandart">${collectedText}</div>
                `;
            } else {
                myActuallyDiv.className += " canTake";
            }
        }
    );
});

$(document).on("click", ".acceptButtonRedeemCode", function () {
    let inputValue = document.getElementById("inputForCode").value;
    if (mdrp) {
        if (inputValue.length == 36) {
            $.post(
                "https://ak4y-battlePass/sendInput",
                JSON.stringify({
                    input: inputValue,
                }),
                function (data) {
                    if (data) {
                        $(".redeemCodeGeneral").hide();
                        showUpgradePremium();
                        setPremiumAreas(true);
                    }
                }
            );
        }
    } else {
        $.post(
            "https://ak4y-battlePass/sendInput",
            JSON.stringify({
                input: inputValue,
            }),
            function (data) {
                if (data) {
                    $(".redeemCodeGeneral").hide();
                    showUpgradePremium();
                    setPremiumAreas(true);
                }
            }
        );
    }
});

$(document).on("click", ".bpItemBoxPremium.canTake", function () {
    let myActuallyDiv = this;
    let rewDetailsString = $(this).attr("data-rewardDetails");
    let rewReqLevel = $(this).attr("data-reqLevel");
    let rewTaskId = $(this).attr("data-taskId");
    let detailParse = JSON.parse(rewDetailsString);
    myActuallyDiv.className = "bpItemBoxPremium";
    $.post(
        "https://ak4y-battlePass/getPremiumReward",
        JSON.stringify({
            itemDetails: detailParse,
            reqLevel: rewReqLevel,
            reqTaskId: rewTaskId,
        }),
        function (data) {
            if (data == true) {
                collectRewardNotify(detailParse);
                $(this).empty();
                myActuallyDiv.innerHTML = `           
                    <div class="itemCollectedTextPremiumx">${collectedText}</div>
                `;
            } else {
                myActuallyDiv.className += " canTake";
            }
        }
    );
});

function collectRewardNotify(data) {
    let itemImage = data.image;
    let count = data.type == "money" ? "$" + data.count : data.count + "pc.";
    document.getElementById("collectedImage").src = itemImage;
    document.getElementById("collectedPrzCount").innerHTML = count;
    $(".collectedSection").fadeIn(500);
    setTimeout(() => {
        $(".collectedSection").fadeOut(500);
        setTimeout(() => {
            $(".collectedSection").hide();
        }, 500);
    }, 2000);
}

function showUpgradePremium() {
    $(".yourAccountUpgradedGeneral").fadeIn(500);
    setTimeout(() => {
        $(".yourAccountUpgradedGeneral").fadeOut(500);
        setTimeout(() => {
            $(".yourAccountUpgradedGeneral").hide();
        }, 500);
    }, 2000);
}

function progressBarCreate(deger) {
    if (deger == 1) {
        taskProgressId1 = new ProgressBar.Circle("#taskBarProgressID-1", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 2) {
        taskProgressId2 = new ProgressBar.Circle("#taskBarProgressID-2", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 3) {
        taskProgressId3 = new ProgressBar.Circle("#taskBarProgressID-3", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 4) {
        taskProgressId4 = new ProgressBar.Circle("#taskBarProgressID-4", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 5) {
        taskProgressId5 = new ProgressBar.Circle("#taskBarProgressID-5", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 6) {
        taskProgressId6 = new ProgressBar.Circle("#taskBarProgressID-6", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 7) {
        taskProgressId7 = new ProgressBar.Circle("#taskBarProgressID-7", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    } else if (deger == 8) {
        taskProgressId8 = new ProgressBar.Circle("#taskBarProgressID-8", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#ff8a8a",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialText",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
            fill: "rgba(0, 0, 0, 0.1)",
        });
    }
}

function premiumProgressCreate(deger) {
    if (deger == 9) {
        taskProgressId9 = new ProgressBar.Circle("#taskBarProgressID-9", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#F8CA48",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialTextPremium",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
        });
    } else if (deger == 10) {
        taskProgressId10 = new ProgressBar.Circle("#taskBarProgressID-10", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#F8CA48",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialTextPremium",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
        });
    } else if (deger == 11) {
        taskProgressId11 = new ProgressBar.Circle("#taskBarProgressID-11", {
            strokeWidth: 7,
            easing: "easeInOut",
            duration: 500,
            color: "#F8CA48",
            trailColor: "#2c2c2c",
            trailWidth: 10,
            text: {
                value: "5/10",
                className: "radialTextPremium",
                style: {
                    color: "#fff",
                    position: "absolute",
                    left: "50%",
                    top: "50%",
                    padding: 0,
                    margin: 0,
                    transform: {
                        prefix: true,
                        value: "translate(-50%, -50%)",
                    },
                },
            },
        });
    }
}

function changeProgressBar(deger, progress, text) {
    if (deger == 1) {
        taskProgressId1.animate(progress);
        taskProgressId1.setText(text);
    } else if (deger == 2) {
        taskProgressId2.animate(progress);
        taskProgressId2.setText(text);
    } else if (deger == 3) {
        taskProgressId3.animate(progress);
        taskProgressId3.setText(text);
    } else if (deger == 4) {
        taskProgressId4.animate(progress);
        taskProgressId4.setText(text);
    } else if (deger == 5) {
        taskProgressId5.animate(progress);
        taskProgressId5.setText(text);
    } else if (deger == 6) {
        taskProgressId6.animate(progress);
        taskProgressId6.setText(text);
    } else if (deger == 7) {
        taskProgressId7.animate(progress);
        taskProgressId7.setText(text);
    } else if (deger == 8) {
        taskProgressId8.animate(progress);
        taskProgressId8.setText(text);
    }
}

function premiumProgressChange(deger, progress, text) {
    if (deger == 9) {
        taskProgressId9.setText(text);
        taskProgressId9.animate(progress);
    } else if (deger == 10) {
        taskProgressId10.animate(progress);
        taskProgressId10.setText(text);
    } else if (deger == 11) {
        taskProgressId11.animate(progress);
        taskProgressId11.setText(text);
    }
}
