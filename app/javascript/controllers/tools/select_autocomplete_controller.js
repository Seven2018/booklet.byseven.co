import { useClickOutside } from 'stimulus-use'
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static get targets () {
    return [ "menu", "input", "hiddenInput", "resultElement" ]
  }

  connect() {
    this.timer
    this.waitTime = 200

    useClickOutside(this)
    this.search()
  }

  toggle () {
    this.menuTarget.classList.toggle('hidden')
  }

  hide () {
    this.menuTarget.classList.add('hidden')
  }

  search(event) {
    if (event && event.type == 'keydown' && this.hiddenInputTarget.value != '' && [8,46].includes(event.keyCode)) {
      event.preventDefault
      this.inputTarget.value = ''
      this.hiddenInputTarget.value = ''
    }

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      const query = this.inputTarget.value
      const path = this.element.dataset.path
      const additional_params = this.element.dataset.additionalParams
      const url = `${path}?search=${query}&${additional_params}`
      const selected_value = this.element.querySelector("input[type='hidden']")

      if (query == '') {
        selected_value.value = ''
      }

      fetch(url)
        .then(response => response.text())
        .then(html => {
          this.menuTarget.innerHTML = html
          this.resultElementTargets.forEach((result) => {
            result.dataset.action += ' ' + this.menuTarget.dataset.elementAction
          })
        })
    }, this.waitTime);
  }

  selectOption(e) {
    const selected_input = this.inputTarget
    const selected_option = e.currentTarget
    const selected_value = this.element.querySelector("input[type='hidden']")

    selected_value.value = selected_option.getAttribute('data-value')
    selected_input.value = selected_option.innerText

    this.hide()
  }

  //////////
  // MISC //
  //////////

  clickOutside(event) {
    this.hide()
  }
}
