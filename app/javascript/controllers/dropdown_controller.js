import { useClickOutside } from 'stimulus-use'
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static get targets () {
    return [ "menu", "display" ]
  }

  connect() {
    useClickOutside(this)
  }

  toggle () {
    this.menuTarget.classList.toggle('hidden')
  }

  hide () {
    this.menuTarget.classList.add('hidden')
  }

  selectOption(e) {
    const element = e.currentTarget
    const selected_display = this.displayTarget
    const selected_option = element.querySelector('p')
    const storage = this.element.querySelector("input[type='hidden']")

    storage.value = selected_option.getAttribute('data-value')
    selected_display.innerText = selected_option.innerText

    this.hide()
  }

  //////////
  // MISC //
  //////////

  clickOutside(event) {
    this.hide()
  }
}
