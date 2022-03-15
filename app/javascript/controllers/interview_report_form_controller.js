import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "togglable" ]
  }

  showTogglable() {
    this.togglableTarget.classList.remove('d-none')
  }

  hideTogglable() {
    this.togglableTarget.classList.add('d-none')
  }
}
