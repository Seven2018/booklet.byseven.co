import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['singleTemplateContainer', 'multipleTemplateContainer', 'categoriesResults', 'requiredInput', 'multiTemplateInput']
  }

  connect() {
    this.setup()
  }

  setup(force_disable = false) {
    this.submit_buttons = document.querySelectorAll('#submit-button')

    if (this.element.dataset.defaultTemplate == '' || force_disable) {
      this.enableButton(false)
    }

    const chosen_category = this.multipleTemplateContainerTarget.dataset.chosenCategory

    if (chosen_category != '') {
      this.multipleTemplateContainerTarget.querySelector(`[data-value='${chosen_category}']`).click()
    }
  }

  chooseSingleTemplate() {
    this.multipleTemplateContainerTarget.classList.add('d-none')
    this.singleTemplateContainerTarget.classList.remove('d-none')
    this.setup(true)
  }

  chooseMultipleTemplate() {
    this.singleTemplateContainerTarget.classList.add('d-none')
    this.multipleTemplateContainerTarget.classList.remove('d-none')
    this.setup(true)
  }

  displayTagsCollection(e) {
    const path = this.categoriesResultsTarget.dataset.path
    const query = e.currentTarget.dataset.value
    const url = `${path}?search=${query}`
    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.categoriesResultsTarget.innerHTML = html

        var chosen_templates = this.multipleTemplateContainerTarget.dataset.chosenTemplates

        if (chosen_templates != '[]') {
          chosen_templates = chosen_templates.substring(1, (chosen_templates.length - 1)).split(', ')

          chosen_templates.forEach((pair) => {
            var tag_id = pair.split(':')[0]
            tag_id = tag_id.substring(1)
            const template_id = pair.split(':')[1]
            var template_title = pair.split(':')[2]
            template_title = template_title.substring(0, (template_title.length - 1))

            if (document.querySelector(`#tag-${tag_id}`) != undefined) {
              document.querySelector(`#tag-${tag_id}`).querySelector('input').value = template_title
              document.querySelector(`#tag-${tag_id}`).querySelector('input[type="hidden"]').value = template_id
            }
          })
        }

        const default_template = document.querySelector('#default_template')

        default_template.classList.remove('d-none')
        default_template.classList.add('d-flex')

        if (default_template.querySelector('input[type="hidden"]').value != '') { this.enableButton(true) }

        this.showMissingTemplateModal()
      })
  }

  enableSubmit(event) {
    if (event.type == 'keydown' && ![8,46].includes(event.keyCode)) {
      return
    }

    const element = event.currentTarget
    var enable = true

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

  showMissingTemplateModal() {
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
  }

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
