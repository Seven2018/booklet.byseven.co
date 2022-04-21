import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "container", "togglable", "input" ]
  }

  connect() {
    this.toggle()
  }

  toggle() {

    const permissions_groups = {
      'user[can_create_employees],user[can_edit_employees],user[can_edit_permissions]': 'user[can_read_employees]',
      'user[can_create_trainings]': 'user[can_read_contents]'
    }

    function toggleInput(input, toggle, container) {
      if (event != undefined) input.checked = !input.checked
      toggle.classList.toggle('left-96pc', input.checked)
      toggle.classList.toggle('left-4pc', !input.checked)
      container.classList.toggle('bg-teal-600', input.checked)
      container.classList.toggle('bg-gray-300', !input.checked)
      if (toggle.dataset.rememberInitialState != 'true') return

      if (toggle.dataset.initial) {
        toggle.classList.toggle('bg-white')
        toggle.classList.toggle('bkt-bg-light-grey6')
      } else {
        toggle.dataset.initial = true
      }

      Object.keys(permissions_groups).forEach((key) => {
        if (key.split(',').includes(input.id)) {
          var target = document.getElementById(permissions_groups[key])
          if (target.checked != input.checked && target.checked == false) {
            var target_toggle = target.parentNode.querySelector('label')
            var target_container = target.parentNode.querySelector('div')
            toggleInput(target, target_toggle, target_container)
          }
        }
      })
    }

    toggleInput(this.inputTarget, this.togglableTarget, this.containerTarget)
  }
}
