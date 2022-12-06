import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="locks"

export default class extends Controller {
  static targets = ["icon", "deck", "parent", "heart", "menu"]
  static values = { menuId: Number }

  connect() {
    console.log("prout")
  }

  async switchl(e) {
    if (e.currentTarget.children[1].classList.toggle('active')) {
      // Remove des favoris
      fetch(`/likes/${this.menuIdValue}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          console.log("ok");
        }
      })
    }
    if (e.currentTarget.children[0].classList.toggle('active')) {
      for (let i = 0; i < 10; i++) {
        // We pass the mouse coordinates to the createParticle() function
        this.createParticle(e.clientX, e.clientY);
      }
    }
  }

  // Change le cadenas de ouvert à fermé, et inversement
  async switchr(event) {
    event.preventDefault();
    let target =  event.currentTarget
    const recipeId = target.dataset.recipeId
    if (target.dataset.method === "post") {
      this.createRecipe(recipeId, target);
    }
  }

  async createRecipe(recipeId, target) {
    fetch(`/menus/${this.menuIdValue}/menu_recipes`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        menu_recipe: {
          recipe_id: recipeId
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        let parent = target.parentNode.parentNode
        target.style.visibility = "hidden";
        this.deckTarget.classList.add('active');
        this.deckTarget.innerHTML += parent.outerHTML;
        parent.outerHTML = "";
      }
    });
  }

  destroyRecipe() {
    fetch(`/menu_recipes/${this.menuIdValue}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        console.log("ok");
      }
    })
  }

  open(){
    let tempo = this.parentTarget.innerHTML;
    this.parentTarget.innerHTML = this.deckTarget.innerHTML.replaceAll("visibility: hidden;", "visibility: visible;") + tempo;
    this.deckTarget.innerHTML = "";
    this.deckTarget.classList.remove('active')
    this.destroyRecipe();
  }

  // Particule EFFECT

  createParticle = (x, y) => {
    // Create a custom particle element
    const particle = document.createElement('particle');
    particle.innerHTML = ['❤','😍', '💕', '💞'][Math.floor(Math.random() * 4)];
    particle.style.fontSize = `${Math.random() * 24 + 10}px`;
    document.body.appendChild(particle);
    // Append the element into the body

    const size = Math.floor(Math.random() * 20 + 5);
    // Apply the size on each particle
    particle.style.width = `${size}px`;
    particle.style.height = `${size}px`;
    particle.style.position = 'absolute';

    // Generate a random color in a blue/purple palette

    const destinationX = x + (Math.random() - 0.5) * 2 * 75;
    const destinationY = y + (Math.random() - 0.5) * 2 * 75;
    particle.style.top = `${y + (Math.random() - 0.5) * 2 * 40}px`;
    particle.style.left = `${x + (Math.random() - 0.5) * 2 * 40}px`;
    // Store the animation in a variable because we will need it later
    const animation = particle.animate([
      {
        // Set the origin position of the particle
        // We offset the particle with half its size to center it around the mouse

        transform: `translate(${x - (size / 2)}px, ${y - (size / 2)}px)`,
        opacity: 1
      },
      {
        // We define the final coordinates as the second keyframe
        transform: `translate(${destinationX}px, ${destinationY}px)`,
        opacity: 0
      }
    ], {
      // Set a random duration from 500 to 1500ms

      duration: 1000 + Math.random() * 1500,
      easing: 'cubic-bezier(0, .9, .57, 1)',
      // Delay every particle with a random value from 0ms to 200ms
      delay: Math.random() * 500
    });
    animation.onfinish = () => {
      particle.remove();
    };
  }
}
