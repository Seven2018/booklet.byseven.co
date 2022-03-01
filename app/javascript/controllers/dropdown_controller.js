import { useClickOutside } from 'stimulus-use'
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static get targets () {
    return [ "menu" ]
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

  clickOutside(event) {
    this.hide()
  }
}
