/* Labex OBVIL 2019 */

/* Options de consultation, pour cocher toutes les options
 * Selon l'état une couleur sera affichée */
const normalisation = {
  'check-lettresRamistes': {'color': '#ffe292', 'class_': 'lettre_ramiste'},
  'check-abreviations': {'color': '#fbd3d3', 'class_': 'abreviation'},
  'check-coquilles': {'color': '#c2e0ae', 'class_': 'sic'},
  'check-cesures': {'color': '#adb9df', 'class_': 'cesure_implicite'},
};

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
        } else {
            el.checked = false;
        }
        highlight(el);
    });
});

function highlight(elementToCheck) {
    /* Surligne un element en fonction de son état */

    let color = normalisation[elementToCheck.id].color;
    let classToColor = normalisation[elementToCheck.id].class_;
    let selectorStr = `[name="${classToColor}"]`;
    let spans = document.querySelectorAll(selectorStr);
    if (elementToCheck.checked){
        spans.forEach(function(span) {
            span.style.backgroundColor = color;
        });
    } else {
        spans.forEach(function(span) {
            span.style.backgroundColor = "initial";
        });
    }
}
