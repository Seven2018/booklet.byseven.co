import { Controller } from "@hotwired/stimulus"
import { debounce } from "debounce"

// TODO make generic. idem toggle_checked_controller with target outside of controller
export default class extends Controller {
  static get targets () {
    return [ "by_employee_form", "by_training_form", "input" ]
  }
  connect() {
    console.log('yeesf')
    this.toggle()
  }

  debouncedToggle() {
    if (this.toggleDebounced) this.toggleDebounced.clear()
    this.toggleDebounced = debounce(this.toggle.bind(this), 100)
    this.toggleDebounced()
  }

  toggle() {
    this.inputTargets.forEach((input) => {
      if (input.checked) {
        input.value == 'by_employee' ? this.showByEmployeeForm() : this.showByTrainingForm()
      }
    })
  }

  showByEmployeeForm() {
    this.by_employee_formTarget.classList.remove('d-none')
    this.by_training_formTarget.classList.add('d-none')
  }

  showByTrainingForm() {
    this.by_employee_formTarget.classList.add('d-none')
    this.by_training_formTarget.classList.remove('d-none')
  }
}
