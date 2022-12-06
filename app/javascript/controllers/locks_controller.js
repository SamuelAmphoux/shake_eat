import { Controller } from "@hotwired/stimulus"
import recipeTemplate from "../templates/recipe.hbs"

// Connects to data-controller="locks"

export default class extends Controller {
  static targets = ["icon", "btn", "card"]
  static values = { menuId: Number, recipeNumber: Number, selectedRecipes: Number}

  connect() {
    console.log(this.recipeNumberValue);

  }

  // Change le cadenas de ouvert à fermé, et inversement
  switch(event) {
    event.preventDefault();
    const target =  event.currentTarget
    const recipeId = target.dataset.recipeId
    if (target.dataset.method === "post") {
      this.createRecipe(recipeId, target)
      target.parentElement.parentElement.classList.remove('unlocked')
    } else if (target.dataset.method === "destroy") {
      const menuRecipeId = target.dataset.menuRecipeId
      this.destroyRecipe(recipeId, menuRecipeId, target)
      target.parentElement.parentElement.classList.add('unlocked')
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
                            </div>`;
        this.selectedRecipesValue += 1;
        if (this.selectedRecipesValue === this.recipeNumberValue) {
          this.btnTarget.classList.remove('generate-disabled')
          this.btnTarget.innerHTML = `<p class="btn-text">Get your list</p>
          <div class="round_btn">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
            </svg>
          </div>`
        } else if (this.selectedRecipesValue !== this.recipeNumberValue) {
          this.btnTarget.classList.add('generate-disabled')
          this.btnTarget.innerHTML = `<p class="btn-text">Select Recipes</p>
          <div class="round_btn">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
            </svg>
          </div>`
        }
      }
    });
  }

  destroyRecipe(recipeId, menuRecipeId, target) {
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
        target.outerHTML = `<div class="recipe_lock" data-locks-target="icon" data-action="click->locks#switch" data-method="post" data-recipe-id="${recipeId}">
                              <i class="fas fa-lock-open"></i>
                            </div>`;
        this.selectedRecipesValue -= 1;
        console.log(this.selectedRecipesValue);
        if (this.selectedRecipesValue === this.recipeNumberValue) {
          this.btnTarget.classList.remove('generate-disabled')
          this.btnTarget.innerHTML = `<p class="btn-text">Get your list</p>
          <div class="round_btn">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
            </svg>
          </div>`
        } else if (this.selectedRecipesValue !== this.recipeNumberValue) {
          this.btnTarget.classList.add('generate-disabled')
          this.btnTarget.innerHTML = `<p class="btn-text">Select Recipes</p>
          <div class="round_btn">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
            </svg>
          </div>`
        }
      }
    })
  }

  getMoreRecipes() {
    fetch(`/menus/${this.menuIdValue}`, {
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
    })
    .then((response) => response.json())
    .then((data) => {
      this.cardTargets.forEach((card)=>{
        if (card.classList.contains('unlocked')) {
          console.log("Je suis là");
          card.remove()
        }
      })
      console.log(data);
      data.forEach((recipe)=>{
        console.log((recipeTemplate(recipe)));
      })
    })
  }
}
