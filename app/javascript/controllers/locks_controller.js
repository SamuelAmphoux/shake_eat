import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="locks"
export default class extends Controller {
  static targets = ["icon"]
  static values = { menuId: Number }
  connect() {
    console.log("Je suis dans le controller locks")
  }

  // Change le cadenas de ouvert à fermé, et inversement
  switch(event) {
    event.preventDefault();
    const target =  event.currentTarget
    const recipeId = target.dataset.recipeId
    if (target.dataset.method === "post") {
      this.createRecipe(recipeId, target)
    } else if (target.dataset.method === "destroy") {
      const menuRecipeId = target.dataset.menuRecipeId
      this.destroyRecipe(recipeId, menuRecipeId, target)
    }
  }

  createRecipe(recipeId, target) {
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
        target.outerHTML = `<div class="recipe_lock" data-locks-target="icon" data-action="click->locks#switch" data-method="destroy" data-menu-recipe-id="${data.menuRecipeId}" data-recipe-id="${recipeId}">
        <i class="fas fa-lock"></i>
      </div>`
      }
    })
  }

  destroyRecipe(recipeId, menuRecipeId, target) {
    fetch(`/menu_recipes/${menuRecipeId}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        target.outerHTML = `<div class="recipe_lock" data-locks-target="icon" data-action="click->locks#switch" data-method="post" data-recipe-id="${recipeId}">
        <i class="fas fa-lock-open"></i>
      </div>`
      }
    })
  }
}
