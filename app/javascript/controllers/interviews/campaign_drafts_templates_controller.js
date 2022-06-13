import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['singleTemplateContainer', 'multipleTemplateContainer', 'categoriesResults', 'requiredInput']
  }

  connect() {
    this.submit_button = document.getElementById('submit-button')

    if (this.element.dataset.defaultTemplate == '') {
      this.submit_button.disabled = true
      this.submit_button.classList.add('disabled')
    }
  }

  chooseSingleTemplate() {
    this.multipleTemplateContainerTarget.classList.add('d-none')
    this.singleTemplateContainerTarget.classList.remove('d-none')
  }

  chooseMultipleTemplate() {
    this.singleTemplateContainerTarget.classList.add('d-none')
    this.multipleTemplateContainerTarget.classList.remove('d-none')
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

    var enable = true

    this.requiredInputTargets.forEach((input) => {
      if (input.querySelector('input[type="hidden"]').value == '') { enable = false }
    })

    if (enable) {
      this.submit_button.disabled = false
      this.submit_button.classList.remove('disabled')
    } else {
      this.submit_button.disabled = true
      this.submit_button.classList.add('disabled')
    }
  }
}
