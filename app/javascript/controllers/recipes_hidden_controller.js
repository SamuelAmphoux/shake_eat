import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recipes-hidden"
export default class extends Controller {

  toggleDescription(event) {
    event.preventDefault()
    const recipeId = event.currentTarget.dataset.recipeId
    const description = document.querySelector(`#description_${recipeId}`)
    description.classList.toggle('hidden')
  }
}
