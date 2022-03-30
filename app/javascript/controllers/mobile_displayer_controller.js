import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['menu', 'body'];
  }

  toggleHomeMenu(_) {
    this.bodyTarget.classList.toggle('d-none')
    this.menuTarget.classList.toggle('d-none')
  }
}