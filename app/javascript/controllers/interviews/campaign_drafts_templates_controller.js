import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['singleTemplateContainer', 'multipleTemplateContainer', 'categoriesResults', 'requiredInput', 'multiTemplateInput']
  }

  connect() {
    this.setup()
  }

  setup() {
    this.submit_buttons = document.querySelectorAll('#submit-button')

    if (this.element.dataset.defaultTemplate == '') {
      this.enableButton(false)
    }
  }

  chooseSingleTemplate() {
    this.multipleTemplateContainerTarget.classList.add('d-none')
    this.singleTemplateContainerTarget.classList.remove('d-none')
    this.setup()
  }

  chooseMultipleTemplate() {
    this.singleTemplateContainerTarget.classList.add('d-none')
    this.multipleTemplateContainerTarget.classList.remove('d-none')
    this.setup()
  }

  displayTagsCollection(e) {
    const path = this.categoriesResultsTarget.dataset.path
    const query = e.currentTarget.dataset.value
    const url = `${path}?search=${query}`
    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.categoriesResultsTarget.innerHTML = html
      })
  }

  enableSubmit(event) {
    if (event.type == 'keydown' && ![8,46].includes(event.keyCode)) {
      return
    }

    const element = event.currentTarget
    var enable = true

    if (this.hasMultiTemplateInputTarget) {
      var missing = false

      this.multiTemplateInputTargets.every((input) => {
        if (input.querySelector('input').value == '') {
          missing = true
          return false
        }
        return true
      })

      if (missing) {
        document.querySelector(".submit-incomplete").classList.remove('d-none')
        document.querySelector(".submit-complete").classList.add('d-none')
      } else {
        document.querySelector(".submit-complete").classList.remove('d-none')
        document.querySelector(".submit-incomplete").classList.add('d-none')
      }
    }

    if (element.closest('.bkt-select-container').querySelector('input[type="hidden"]').value == '') { enable = false }

    if (enable) {
      this.enableButton(true)
    } else {
      this.enableButton(false)
    }
  }

  /////////////
  // PRIVATE //
  /////////////

  enableButton(boolean) {

    this.submit_buttons.forEach((button) => {
      if (boolean) {
        button.disabled = false
        button.classList.remove('disabled')
      } else {
        button.disabled = true
        button.classList.add('disabled')
      }
    })
  }
}
