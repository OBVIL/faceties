
/* Options de consultation, pour cocher toutes les options
 * Selon l'état une couleur sera affichée */
const normalisation = [
  {"id": 'check-lettresRamistes', "color": '#ffe292'},
  {"id": 'check-abreviations', "color": '#fbd3d3'},
  {"id": 'check-coquilles', "color": '#c2e0ae'},
  {"id": 'check-cesures', "color": '#adb9df'},
];

const optionsConsultation = document.querySelector("#customSwitch1");
const checkItems = document.querySelectorAll(".check-all");
checkItems.forEach(function(el) {
    el.addEventListener('click', function() {
        highlight(this);
    });
});

optionsConsultation.addEventListener('change', function() {
    isChecked = this.checked;
    checkItems.forEach(function(el) {
        if (isChecked) {
            el.checked = true;
            highlight(el);
        } else {
            el.checked = false;
            highlight(el);
        }
    });
});

function highlight(el){
    /* Surligne un element en fonction de son état */
    let color = find_color(el.id);
    if (el.checked){
        document.querySelector('#pipou').style.backgroundColor = color;
    } else {
        document.querySelector('#pipou').style.backgroundColor = "initial";
    }
}

function find_color(element_id) {
    /* Trouve la couleur d'un élément en fonction de son #id */
    for (let i = 0; i < normalisation.length; i++) {
        if (normalisation[i].id === element_id) {
            return normalisation[i].color;
        }
    }
    console.log("L'id n'existe pas")
    return "initial";
}
