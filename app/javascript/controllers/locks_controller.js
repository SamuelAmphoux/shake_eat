import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="locks"

export default class extends Controller {
  static targets = ["icon", "deck", "parent"]
  static values = { menuId: Number }
  connect() {
    console.log(this.deckTarget)
    console.log(this.menuIdValue)
  }

  // Change le cadenas de ouvert à fermé, et inversement
  async switch(event) {
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
}
