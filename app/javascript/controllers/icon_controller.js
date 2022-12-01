import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="icon"
export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    console.log('hello')
  }

  toggleInactiveClass() {
    console.log('bibi')
    console.log('baba')
  }
}
