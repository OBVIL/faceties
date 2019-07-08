/* I. BUT : 
- ajouter des checkbox à l'html sans modifier celui-ci (selon ce format : <div><INPUT type="checkbox" id="monophtonguaison" value="monophtongaison" onclick="affiche_transformation(this.id);">monophtongaisons</div>); 
- créer une checkbox par normalisation */
/* couleurs à utiliser : 
ffedbb ; ffe292 ; ffdc7e ; adb9df ; ffdaa3 ; 
7da7d9 ; bae4f0 ; 81d2e5 ; fdd0af ; f8a980 ; 
f68b79 ; 7bcbbe ; fbd3d3 ; f8a19a ; bee3d2 ; 
e7bad7 ; d792bf ; c2e0ae ; acd589 ; c7b1d5 ; 
e2ecaf ; dde89a ; d7e37d*/

/* I.1. CREATION DES CHECKBOX (+ afficher "tout cacher") */

var normalisation = [
  {"id": 'lettre_ramiste', "TextNode": 'Lettres ramistes', "color": '#ffe292'},
  {"id": 'abreviation', "TextNode": 'Abréviations', "color": '#fbd3d3'},
  {"id": 'sic', "TextNode": 'Coquilles', "color": '#c2e0ae'},
  {"id": 'cesure_implicite', "TextNode": 'Césures Implicites', "color": '#adb9df'},
 ];

function initialise_affichage () {

  var affiche = document.getElementById("afficher");

  normalisation.forEach(function(norm) {
    var check = document.createElement('INPUT');
    check.type = "checkbox";
    check.id = norm.id ;
    check.value = norm.id ;
    check.setAttribute('onclick','affiche_transformation(this.id);'); 
    var text = document.createTextNode(norm.TextNode);
    var div = document.createElement('div');
    div.appendChild(check);
    div.appendChild(text);
    affiche.insertBefore(div,affiche.firstChild);
  });

  /* II.1 : Tout cacher (voir explication plus bas) */

  // Changements éffectués sur l'apparence des boutons :
  document.getElementById('cache_reg').checked = true; // coché pour le lancer par défaut au lancement de la page (mise à zéro)...
  document.getElementById('affiche_reg').checked = false; // - donc "affiche tout" décoché ; 
}

/* I.2. APPEL DES FONCTIONS : pour permettre l'application de plusieurs fonctions en même temps */

function affiche_transformation(id) {
  // Les if suivants permettent d'assigner une couleur à un id : ils définissent valeur de la variable id ; valeur de color sera reprise par la varaible couleur
  normalisation.forEach(function(norm) {
    if (id == norm.id) color = norm.color;
  });

  if(document.getElementById(id).checked == true) { // Si la case vient d'être cochée... 
    modifie_spans(id,color); // - appel de la fonction modifie_spans() pour la normalisation voulue = afficher (couleur : x ; taille : 100%) ;
    document.getElementById('cache_reg').checked = false; // - et décocher le bouton "cache tout" car au moins une case est cochée.

  } else { // Si, au contraire, la case vient d'être décochée... 
    modifie_spans(id,'inherit'); // appel de la fonction modifie_spans() pour la normalisation voulue = cacher (couleur : inherit ; taille : 100%) ;
    document.getElementById('affiche_reg').checked = false; // - et décocher le bouton "affiche tout" car au moins une case est décochée.
  }
}

/* I.3. APPLIQUER LA MODIFICATION : couleur + taille selon la classe demandée */
function modifie_spans (classe,couleur,taille) {
  var spans = document.getElementsByTagName('span');
      for (span of spans) {
          if (span.getAttribute('name') == classe) {
              span.style.backgroundColor = couleur;
              var enfants = span.childNodes;
              for (e of enfants) {
              }
          }
   }
}

/* II. BUT : tout afficher ou tout cacher */

/* II.1. TOUT CACHER */
function cache_tout_reg () { // cf. <body onload="cache_tout_reg();"> : lancement de la fonction au lancement de la page

  // Changements éffectués sur l'apparence des boutons :
  document.getElementById('cache_reg').checked = true; // coché :
  document.getElementById('affiche_reg').checked = false; // - donc "affiche tout" décoché ; 
  
  normalisation.forEach(function(norm) { // - ainsi que toutes les checkbox au lancement de la page. 
    document.getElementById(norm.id).checked = false;
  });
  
  // Changements éffectués sur spans dans le texte :
  normalisation.forEach(function(norm) { // appel la fonction modifie_spans() pour toutes les normalisations = cacher (couleur : inherit ; taille : 100%) ;
    modifie_spans(norm.id,'inherit');
  });
}

/* II.2. TOUT AFFICHER */
function affiche_tout_reg () { // inverse de cache_tout_reg()
  document.getElementById('cache_reg').checked = false; 
  document.getElementById('affiche_reg').checked = true; 

  normalisation.forEach(function(norm) { 
    document.getElementById(norm.id).checked = true;
  });
  
  normalisation.forEach(function(norm) { 
    modifie_spans(norm.id,norm.color);
  });

}