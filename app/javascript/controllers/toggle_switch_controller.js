import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "togglable", "input" ]
  }

  connect() {
    this.toggle()
  }

  toggle() {
    this.togglableTarget.classList.toggle('left-96pc', this.inputTarget.checked)
    this.togglableTarget.classList.toggle('left-4pc', !this.inputTarget.checked)
    this.element.classList.toggle('bg-teal-600', this.inputTarget.checked)
    this.element.classList.toggle('bg-gray-300', !this.inputTarget.checked)
    if (this.togglableTarget.dataset.rememberInitialState != 'true') return

    if (this.togglableTarget.dataset.initial) {
      console.log('doing this')
      this.togglableTarget.classList.toggle('bg-white')
      this.togglableTarget.classList.toggle('bkt-bg-light-grey6')
    } else {
      this.togglableTarget.dataset.initial = true
    }
  }
}
