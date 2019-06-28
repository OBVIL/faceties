/* CHEVALIER Nolwenn. OBVIL, projet Facéties. 27/05/2019. 
Ce script permet de générer un bouton radio par <speaker>. Ces boutons radio permettent de différencier un speaker des autre (choix : italic). */

/* Requiert :  
- HTML : <sp who="lacteur">
- HTML : <body onload="initialise_radio();">
- HTML : <div id="afficher"><input type="radio" id="zero" name="affichage" value="zero" onclick="reinitialisation()"><label for="zero">Aucun</label></div>
- CSS : div#afficher div {text-transform: capitalize;} (pour mettre une majuscule aux noms/texte des boutons radios)
 */

function prepare_tableau () {

// On récupère toutes les valeurs des @who des <sp> :
	ALL_TABL_speakers = [];
		var actors = document.getElementsByTagName("sp");
		for (actor of actors) {
			if (actor.getAttribute("who")) {
				var pers = actor.getAttribute("who");
				ALL_TABL_speakers.push(pers);
			}
		}

// On éfface les doublons du tableau :
	function cleanArray(array) {
		var i, j, len = array.length, out = [], obj = {};
		for (i = 0; i < len; i++) {
			obj[array[i]] = 0;
    }
		for (j in obj) {
		out.push(j);
		}
	return out;
  }

// On appelle nos deux premières fonction pour produire un nouveau tableau propre : 
var TABL_speakers = cleanArray(ALL_TABL_speakers);

// On permet l'appel du tableau dans différentes fonctions :
return TABL_speakers;
}

function initialise_radio() {
TABL_speakers = prepare_tableau ();
document.getElementById('zero').checked = true;

// Remplacement des "_" par des espaces :
  class RegExp1 extends RegExp {
    [Symbol.replace](str) {
    return RegExp.prototype[Symbol.replace].call(this, str, ' ');
    }
  }

// On créé un bouton radio par <speaker> : 
  var affiche = document.getElementById("afficher");
  TABL_speakers.forEach(function(element) {
      var check = document.createElement("INPUT");
      check.type = "radio";
      check.name = "affichage";
      check.id = element;
      check.value = element ;
      check.setAttribute("onclick","affiche_transformation()"); 
      var text = document.createTextNode(element.replace(new RegExp1('_')));
      var div = document.createElement("div");
      div.appendChild(check);
      div.appendChild(text);
      affiche.insertBefore(div,affiche.firstChild);
    });
}

function affiche_transformation() {
TABL_speakers = prepare_tableau ();

// On remet tout à zéro avant d'afficher de nouvelles modifications (c'est-à-dire qu'un seul bouton radio ne peut être coché à la fois grâce à cela) : 
	TABL_speakers.forEach(function(element) {
		enlever();
	});

// On regarde si le bouton de l'élément choisi est coché :
	TABL_speakers.forEach(function(element) {
		if(document.getElementById(element).checked == true) {
			myFunction(element, "italic");
		}
	});
}

function myFunction(element, SPstyle) {
// On applique un style différencié à l'élément choisi :
	var speakers = document.getElementsByTagName("sp");
	for (speaker of speakers) {
		if (speaker.getAttribute("who") == element) {
			speaker.style.fontStyle = SPstyle; 
			}
	}
}

function reinitialisation() {
	TABL_speakers = prepare_tableau ();

// Pour n'avoir aucun style différencié : 
  TABL_speakers.forEach(function(element) {
		enlever();
	});
}

function enlever() {
  
  // On applique un style non-différencié aux éléments : 
	TABL_speakers.forEach(function(element) {
		myFunction(element,"normal");
	});
}