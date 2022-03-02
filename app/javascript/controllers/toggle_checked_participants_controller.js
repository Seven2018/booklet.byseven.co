import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "icon", "togglable" ]
  }

  connect() {
    this.toggle()
  }

  toggle() {
    this.iconTarget.classList.toggle('hidden', !this.togglableTarget.checked)
  }
}
