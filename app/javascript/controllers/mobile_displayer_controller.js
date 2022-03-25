import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['menu', 'body'];
  }

  toggleHomeMenu(_) {
    $(this.bodyTarget).toggleClass('d-none')
    $(this.menuTarget).toggleClass('d-none')
  }
}