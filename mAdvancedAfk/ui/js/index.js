const menu = document.getElementById("menuPrincip")
const afkModes = document.getElementById("ModesCat");
const afkTop = document.getElementById("TopsCat");
const confirmmenu = document.getElementById("confirmpage")
const AfkCards = document.getElementById("mod")
const confirmAudio = document.getElementById("confirmaudio")
const selectAudio = document.getElementById("selectaudio")
const afkTimer = document.getElementById("afktimer")

let lastElemnt = afkModes;
let isConfirmShow = false;
let isProcess = false
let ElementSelected = false

window.addEventListener('message', function(e) {
    let event = e.data;

    if (event.type == "showUI") {
        showUI()
    } 
    if (event.type == "hideUI") {
        hideUI()
    }
    if (event.type == "setModesAfk") {
        setAfkModes(event.modes)
    } 
    if (event.type == "setAfk") {
        setAfkInProcess(event.afk)
    }
    if (event.type == "showAfkTimer") {
        const timer = document.getElementById("timeAfk")
        timer.innerHTML = event.timer
        afkTimer.classList.remove("hide")
    }
    if (event.type == "hideAfkTimer") {
        afkTimer.classList.add("hide")
    }
    if (event.type == "updateAfkTimer") {
        const timer = document.getElementById("timeAfk")
        timer.innerHTML = event.timer
    }
    if (event.type == "afkTerminate") {
        ElementSelected = false
        isProcess = false
        isConfirmShow = false
    }
    if (event.type == "refreshLeader") {
        setTopLeader(event.data)
    }
})

const setAfkModes = async(modes) => {
    if (!modes) return;
    
    AfkCards.innerHTML = ""

    await modes.map((mode, key) => {
        const cube = document.createElement("div");
        cube.className = "cube";

        const hourstext = document.createElement("h1")
        hourstext.innerText = `Heures ${mode.hours}`

        cube.appendChild(hourstext);

        const image = document.createElement("img")
        image.src = `images/${mode.image}`

        cube.appendChild(image);

        const rewardtext = document.createElement("p")
        rewardtext.innerText = `${mode.moneyReward}$`

        cube.appendChild(rewardtext);

        cube.addEventListener("click", () => {
            ElementSelected = mode
            showConfirm()
        });

        AfkCards.appendChild(cube)        
    })
}

const setAfkInProcess = async(Afk) => {
    if (!Afk) return;
    
    AfkCards.innerHTML = ""
    
    const cube = document.createElement("div");
    cube.className = "cube";

    const hourstext = document.createElement("h1")
    hourstext.innerText = `Minutes ${Afk.hours}`

    cube.appendChild(hourstext);

    const image = document.createElement("img")
    image.src = `images/${Afk.image}`

    cube.appendChild(image);

    const rewardtext = document.createElement("p")
    rewardtext.innerText = `${Afk.moneyReward}$`

    cube.appendChild(rewardtext);

    cube.addEventListener("click", () => {
        hideUI()

        $.post('https://mAdvancedAfk/goToAfk', JSON.stringify({Afk}))
    });

    AfkCards.appendChild(cube)     
    isProcess = true
}

const setTopLeader = async (data) => {
    if (!Array.isArray(data)) return;

    afkTop.innerHTML = "";

    await data.map((afkPlayer, key) => {
        const bloc_top = document.createElement("div");
        bloc_top.className = "bloc_top";

        const image_tr = document.createElement("img");
        image_tr.src = `images/tr${afkPlayer.top}.png`;

        bloc_top.appendChild(image_tr);

        const pos_separator = document.createElement("div");
        pos_separator.className = "pos_separator";

        bloc_top.appendChild(pos_separator);

        const separator = document.createElement("div");
        separator.className = "separator";

        pos_separator.appendChild(separator);

        const text_position = document.createElement("div");
        text_position.className = "text_position";

        bloc_top.appendChild(text_position);

        const name = document.createElement("h1");
        name.className = "name";
        name.innerHTML = afkPlayer.name;

        text_position.appendChild(name);

        const afk_number1 = document.createElement("p");
        afk_number1.className = "afk_number";
        afk_number1.innerHTML = `Afks réalisés : <span class="span_number">${afkPlayer.afks}</span>`;

        text_position.appendChild(afk_number1);

        const afk_number2 = document.createElement("p");
        afk_number2.className = "afk_number";
        afk_number2.innerHTML = `Argent gagné : <span class="span_number">${afkPlayer.money}$</span>`;

        text_position.appendChild(afk_number2);

        const afk_number3 = document.createElement("p");
        afk_number3.className = "afk_number";
        afk_number3.innerHTML = `Nombre d’heures : <span class="span_number">${afkPlayer.hours}H</span>`;

        text_position.appendChild(afk_number3);

        afkTop.appendChild(bloc_top);
    });
}

function showUI() {
    menu.classList.remove("hide")
    $.post('https://mAdvancedAfk/showUI', JSON.stringify({}))
}

function hideUI() {
    menu.classList.add("hide")
    $.post('https://mAdvancedAfk/hideUI', JSON.stringify({}))
}

function showTops() {
    if (afkTop == lastElemnt || isConfirmShow) {
        return;
    }

    if (lastElemnt) {
        lastElemnt.classList.add("hide");
    }

    afkTop.classList.remove("hide");
    lastElemnt = afkTop;
}


function showModes() {
    if (afkModes == lastElemnt || isConfirmShow) {
        return;
    }

    if (lastElemnt) {
        lastElemnt.classList.add("hide");
    }

    afkModes.classList.remove("hide");
    lastElemnt = afkModes;
}

function showConfirm() {
    if (isConfirmShow) {
        return;
    }

    confirmAudio.volume = 0.4
    confirmAudio.play();

    confirmmenu.classList.remove("hide")
    isConfirmShow = true
}


function confirmSelect(accepted) {
    confirmmenu.classList.add("hide")

    selectAudio.volume = 0.3
    selectAudio.play();

    if (accepted) {
        hideUI()
        $.post('https://mAdvancedAfk/afkstart', JSON.stringify({ElementSelected}))
    }
    
    isConfirmShow = false
}