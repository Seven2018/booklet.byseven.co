import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return []
  }

  connect() {
    this.timer
    this.waitTime = 500

    this.element[
      (str => {
        return str
          .split('--')
          .slice(-1)[0]
          .split(/[-_]/)
          .map(w => w.replace(/./, m => m.toUpperCase()))
          .join('')
          .replace(/^\w/, c => c.toLowerCase())
      })(this.identifier)
    ] = this
  }

  allowNextStep(boolean = true) {
    const next_button = this.element.querySelector('.step:not(.d-none)').querySelector('.button-next')

    if (boolean) {
      next_button.disabled = false
      next_button.classList.remove('disabled')
    } else {
      next_button.disabled = true
      next_button.classList.add('disabled')
    }

  }

  nextStep() {
    const current_step = this.element.querySelector('.step:not(.d-none)')
    const next_step = this.element.querySelector(`#step-${(parseInt(current_step.id.split('-')[1], 10) + 1).toString()}`)

    current_step.classList.toggle('d-none')
    next_step.classList.toggle('d-none')
  }

  reset() {
    this.element.querySelectorAll('.step').forEach((step) => {
      if (step.id == 'step-1') {
        step.classList.remove('d-none')
      } else {
        step.classList.add('d-none')
      }
    })

    this.element.querySelectorAll('input:not([type="submit"])').forEach((input) => {
      if (input.dataset.noReset == undefined) {
        input.value = ''
      }
    })
  }

}
