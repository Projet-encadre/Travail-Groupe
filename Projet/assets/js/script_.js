$(document).ready(function () {
    // Initialisation de SimpleBar pour tous les éléments avec l'attribut 'data-simplebar'

    document.querySelectorAll('[data-simplebar]').forEach(function (element) {
        new SimpleBar(element);
    });    

    /* Le défilement */

    // Le bouton pour aller en bas
    document.querySelector('.go-down').addEventListener('click', () => {
        window.scrollTo({
            top: document.body.scrollHeight,
            behavior: 'smooth'
        });
    });
    


    /* Le bouton pour revenir en haut ne s'affichera que lorsque la distance de détection du défilement dépasse 50 depuis le haut. */
    let scrollTimeout;
    
    $(window).scroll(function () {
        clearTimeout(scrollTimeout);

        scrollTimeout = setTimeout(function () {
            if ($(window).scrollTop() > 50) {
                $(".back-top").removeClass("hide");
            } else {
                $(".back-top").addClass("hide");
            }
        }, 100); // Déclenche toutes les 100ms
    });


    // L'appui sur le bouton pour revenir en haut
    $(".back-top").on("click", function (event) {
        $("html, body").animate(
            {
                scrollTop: 0
            },
            500 // Le temps pour revenir en haut de la page est de 500 millisecondes
        );
    });
});


// Le rideau sticky
// Script pour ajouter la classe sticky
window.onscroll = function() {
    let header = document.querySelector('header');
    if (window.pageYOffset > 0) {
        header.classList.add('sticky');
    } else {
        header.classList.remove('sticky');
    }
};

// ============================================================

const header = document.querySelector("header");

window.addEventListener ("scroll", function() {
    header.classList.toggle ("sticky", window.scrollY > 130);
});


// La navbar

document.addEventListener('DOMContentLoaded', () => {
    let menuIcon = document.querySelector('#menu-icon');
    let navbar = document.querySelector('.navbar');

    menuIcon.addEventListener('click', () => {
        navbar.classList.toggle('show-menu');
    });

    // Fermer le menu si on clique ailleurs
    document.addEventListener('click', (event) => {
        if (!menuIcon.contains(event.target) && !navbar.contains(event.target)) {
            navbar.classList.remove('show-menu');
        }
    });
});


// ============================================================

// Pour que le bouton du menu déclenche l'apparition ou la disparition de la <nav class="other_links">
const menuIcon = document.getElementById('menu-icon');
const otherLinks = document.querySelector('.other_links');

// Bascule l'affichage du menu en cliquant sur le bouton
menuIcon.addEventListener('click', () => {
    menuIcon.classList.toggle('bx-x'); // Change l'icône du menu entre ouvert et fermé
    otherLinks.classList.toggle('show-menu'); // Ajoute/retire la classe `show-menu` sur .other_links pour afficher/masquer les liens
});

// Fermer le menu en cliquant à l'extérieur
document.addEventListener('click', (event) => {
    if (!menuIcon.contains(event.target) && !otherLinks.contains(event.target)) {
        menuIcon.classList.remove('bx-x');
        otherLinks.classList.remove('show-menu');
    }
});

menuIcon.addEventListener('click', () => {
    otherLinks.style.transform = otherLinks.style.transform === 'translateX(0)' ? 'translateX(100%)' : 'translateX(0)';
    otherLinks.style.opacity = otherLinks.style.opacity === '1' ? '0' : '1';
});


// ==================================================================================

// Gestion de la "expandable section" 
// Gestion des sections extensibles
document.addEventListener('DOMContentLoaded', () => {
    // Sélectionne tous les liens ayant la classe "expand-link"
    const expandLinks = document.querySelectorAll('.expand-link');

    // Ajoute un événement pour chaque lien
    expandLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault(); // Empêche le comportement par défaut du lien
            
            // Récupère l'ID de la section cible à partir d'un attribut data-section
            const sectionId = link.getAttribute('data-section');
            const section = document.getElementById(sectionId);

            if (section) {
                // Ferme toutes les autres sections
                const allSections = document.querySelectorAll('.expandable-section');
                allSections.forEach(sec => {
                    if (sec !== section) {
                        sec.classList.remove('open');
                    }
                });

                // Basculer la classe 'open' pour la section cible
                section.classList.toggle('open');
            }
        });
    });
});


// ======================================================================================================

// Script pour gérer la fonctionnalité du menu déroulant

// Récupère les références au bouton du menu déroulant et à la section de contenu du menu
const dropdownButton = document.getElementById('journal-de-bord');
const dropdownSection = document.getElementById('journal-section');

// Ajoute un écouteur d'événement au clic sur le bouton du menu déroulant
// Cela permet d’alterner la visibilité du menu déroulant et de mettre à jour les attributs ARIA pour l’accessibilité
dropdownButton.addEventListener('click', () => {
  // Vérifie si le menu déroulant est actuellement ouvert (true/false)
  const isExpanded = dropdownButton.getAttribute('aria-expanded') === 'true';
  
  // Met à jour l'attribut aria-expanded pour refléter le nouvel état
  dropdownButton.setAttribute('aria-expanded', !isExpanded);
  
  // Met à jour l'attribut aria-hidden pour indiquer la visibilité de la section du menu déroulant
  dropdownSection.setAttribute('aria-hidden', isExpanded);
  
  // Modifie la propriété display pour afficher ou masquer le menu déroulant
  // Cela peut également être remplacé par l’ajout ou la suppression de classes CSS pour un meilleur contrôle du style
  dropdownSection.style.display = isExpanded ? 'none' : 'block';
});


// ===============la fluidité pour la navbar ============================

let navLinks = document.querySelectorAll('nav a');
let sections = document.querySelectorAll('section');

navLinks.forEach(link => {
    link.addEventListener('click', e => {
        e.preventDefault();
        const target = document.querySelector(link.getAttribute('href'));
        const targetTop = target.offsetTop;
        window.scrollTo({
            top: targetTop,
            behavior: "smooth"
        });
    });
});

window.addEventListener('scroll', () => {
    let current = '';
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (pageYOffset >= (sectionTop - sectionHeight / 3)) {
            current = section.getAttribute('id');
        }
    });
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href').includes(current)) {
            link.classList.add('active');
        }
    });
});


// =====================================================================================

// Le sous-menu qui sort du <button> du lien de la navbar

const dropdownMenu = document.getElementById('dropdown-menu');
document.body.appendChild(dropdownMenu); // Déplace le sous-menu en dehors de la navbar


journalDeBord.addEventListener('click', (e) => {
    e.preventDefault();
    dropdownMenu.classList.toggle('active');

    // Récupère les coordonnées du lien
    const rect = journalDeBord.getBoundingClientRect();
    const dropdownContainer = document.getElementById('dropdown-container');

    dropdownContainer.style.top = `${rect.bottom}px`;
    dropdownContainer.style.left = `${rect.left}px`;
});