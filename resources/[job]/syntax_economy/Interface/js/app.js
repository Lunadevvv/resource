let itemImageURL = "nui://esx_inventoryhud/html/img/items/";
let currentSlot = 0;
let currentItem = [];
let itemList = [];
let CONFIG = [];

window.addEventListener("message", event => {
    const data = event.data;

    if (data.action == "display") {
        currentSlot = 0;
        if(data.type == "sell") {
            $(".economy-check").hide();
            $(".economy-sell").show();      
        } else {
            $(".economy-sell").hide();
            $(".economy-check").show();
        }

        $(".main-content").fadeIn(200);
    } else if (data.action == "setItems") {
        itemList = data.items;
        setEconomyList();
    } else if (data.action == "setCheckItems") {
        EconomyCheckListSetup(data.items);
    } else if (data.action == "hide") {
        $(".main-content").fadeOut(200);
    } else if (data.action == "updateItems") {
        refreshNew(data.itemData);
    } else if (data.action == "setConfig") {
        itemImageURL = data.Config.itemImage;
        CONFIG = data.Config;
        $.post("http://syntax_economy/stopNUI")
    }

})

refreshNew = (itemData) => {
    $(".header-name").html(itemData.label);
}

setEconomyList = () => {
    currentItem = [];
    $(".economy-list .flex").html('');    
    for (const [key, value] of Object.entries(itemList)) {
        if (key == 0) {
            refreshNew(value);
        }
        currentItem[value.label] = {
            data: value,
            index: key
        };
        if (value.price > 50) {
            price =  value.price + "<span style='color:green'>▴</span>";
        }else if (value.price < 50) {
            price =  value.price + "<span style='color:red'>▾</span>";
        }else{
            price =  value.price + "&nbsp;&nbsp;&nbsp;";
        }
        let TPL2 = $(`
                        <div class="flex-item">
                            <div class="item-image">
                                <img src="${itemImageURL + value.name}.png" onerror="this.src='img/error.png'">
                            </div>
                            <div class="item-label">
                                ${value.label}
                            </div>
                            <div id="item-price-${key}" class="item-price">
                                $${price}
                            </div>
                        </div>`)
        $("#item-"+key).data("item", value);
        $(".economy-list .flex").append(TPL2);
    }
    
    $(".grid").html('');    
    for (const [key, value] of Object.entries(itemList)) {
        if (key == 0) {
            refreshNew(value);
        }
        currentItem[value.label] = {
            data: value,
            index: key
        };

        
        if (value.count > 0) {
            itemcount = "";
        } else {
            itemcount = "filter: grayscale(100%);";
        }

        let TPL = $(`
                        <div class="grid-item ${(key == currentSlot ? "selected" : "")}" index="${key}" id="item-${key}">
                            <div class="item-image">
                                <img src="${itemImageURL + value.name}.png" onerror="this.src='img/error.png'" style="${itemcount}">      
                            </div>
                            <div class="item-label">
                                ${value.label}
                            </div>
                        </div>`)
        $("#item-"+key).data("item", value);
        $(".grid").append(TPL);

        $("#item-"+key).click(function() {
            if (currentSlot !== key) {
                currentSlot = key;
                $(".grid-item").removeClass("selected");
                $(this).addClass("selected");
                refreshNew(value);
            }
        });
    }        
}

/*onkeyup = () => {
    $("#total-price").html(($("#count").val() == "" ? "0" : currentItem[$(".header-name").html()].data.price * parseInt($("#count").val())) + " $")
};*/


EconomyCheckListSetup = (itemList) => {
    $(".economy-list .flex").html('');
    for (const [key, value] of Object.entries(itemList)) {
        if (value.price > 50) {
            price =  value.price + "<span style='color:green'>▴</span>";
        }else if (value.price < 50) {
            price =  value.price + "<span style='color:red'>▾</span>";
        }else{
            price =  value.price + "&nbsp;&nbsp;&nbsp;";
        }
        let TPL = $(`
                        <div class="flex-item ${(key == currentSlot ? "" : "")}" index="${key}" id="item-${key}">
                            <div class="item-image">
                                <img src="${itemImageURL + value.name}.png" onerror="this.src='img/error.png'">
                            </div>
                            <div class="item-label">
                                ${value.label}
                            </div>
                            <div class="item-price">
                                $${price}
                            </div>
                        </div>`)
                    
        $(".economy-list .flex").append(TPL);
    }
}

$(document).ready(function () {
    $("body").on("keyup", function (key) {
        if ([113, 27, 90].includes(key.which)) {
            $.post("http://syntax_economy/FOCUSOFF", JSON.stringify({}));
        }
    });

    $("#sellCount").click(function() {
        if ($("#count").val() != "") {
            $.post("http://syntax_economy/sellItems", JSON.stringify({
                count: parseInt($("#count").val()),
                itmData: currentItem[$(".header-name").html()].data,
            }))
        }
    })

    $("#sellAll").click(function() {
        $.post("http://syntax_economy/sellAllItems", JSON.stringify({
            itmData: currentItem[$(".header-name").html()].data,
        }))
    })
});