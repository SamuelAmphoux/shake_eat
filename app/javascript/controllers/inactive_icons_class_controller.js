import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="inactive-icons-class"
export default class extends Controller {
  static targets = ["icon"]

  connect() {
    console.log('hello')
  }

  toggleInactiveClass(event) {
    event.currentTarget.classList.toggle('inactive')
  }
}
