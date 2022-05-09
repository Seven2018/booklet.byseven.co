import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "icon", "togglable" ]
  }

  connect() {
    this.toggle()
  }

  toggle() {
    const border_color = this.togglableTarget.dataset.bordercolor ? this.togglableTarget.dataset.bordercolor : 'border-bkt-blue-0_5px'

    this.iconTarget.classList.toggle('hidden', !this.togglableTarget.checked)
    this.togglableTarget.closest('label').classList.toggle('border-bkt-light-grey5-0_5px', !this.togglableTarget.checked)
    this.togglableTarget.closest('label').classList.toggle(border_color, this.togglableTarget.checked)
  }
}
