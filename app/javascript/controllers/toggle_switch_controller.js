import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "container", "togglable", "input" ]
  }

  connect() {
    this.toggle()
  }

  toggle() {

    const permissions_group_true = {
      'user[can_create_employees],user[can_edit_employees],user[can_edit_permissions]': 'user[can_read_employees]',
      'user[can_create_trainings],user[can_create_contents]': 'user[can_read_contents]'
    }

    const permissions_group_false = {
      'user[can_read_employees]': 'user[can_create_employees],user[can_edit_employees],user[can_edit_permissions]',
      'user[can_read_contents]': 'user[can_create_contents],user[can_create_trainings]'
    }

    const permissions_groups = {
      'true': permissions_group_true,
      'false': permissions_group_false
    }

    const controls = document.getElementById('control-buttons')
    const inputs = document.querySelectorAll('input[type="checkbox"]')

    function toggleInput(input, toggle, container) {
      if (event != undefined) input.checked = !input.checked
      toggle.classList.toggle('left-96pc', input.checked)
      toggle.classList.toggle('left-4pc', !input.checked)
      if (toggle.dataset.rememberInitialState != 'true') return

      if (toggle.dataset.initial) {
        if (input.checked && input.dataset.initialState == 'false') {
          toggle.classList.add('bkt-bg-green-important')
          container.classList.add('bkt-bg-transparent-green-important')
          toggle.classList.remove('bkt-bg-negative-red-important')
          container.classList.remove('bkt-bg-transparent-negative-red-important')
        } else if (!input.checked && input.dataset.initialState == 'true') {
          toggle.classList.add('bkt-bg-negative-red-important')
          container.classList.add('bkt-bg-transparent-negative-red-important')
          toggle.classList.remove('bkt-bg-green-important')
          container.classList.remove('bkt-bg-transparent-green-important')
        } else {
          toggle.classList.remove('bkt-bg-negative-red-important')
          container.classList.remove('bkt-bg-transparent-negative-red-important')
          toggle.classList.remove('bkt-bg-green-important')
          container.classList.remove('bkt-bg-transparent-green-important')
        }
      } else {
        toggle.dataset.initial = true
      }

      Object.keys(permissions_groups).forEach((boolean) => {
        Object.keys(permissions_groups[boolean]).forEach((key) => {
          if (key.split(',').includes(input.id)) {
            permissions_groups[boolean][key].split(',').forEach((target_ref) => {
              var target = document.getElementById(target_ref)
              var condition = !(boolean == 'true')
              if (target != null && target.checked != input.checked && target.checked == condition) {
                var target_toggle = target.parentNode.querySelector('label')
                var target_container = target.parentNode.querySelector('div')
                toggleInput(target, target_toggle, target_container)
              }
            })
          }
        })
      })


    }

    toggleInput(this.inputTarget, this.togglableTarget, this.containerTarget)

    var counter = 0
    inputs.forEach((input) => {
      if (input.checked.toString() != input.dataset.initialState) {
        controls.classList.remove('hidden')
        return
      }
      counter += 1
    })
    if (counter == inputs.length) controls.classList.add('hidden')
  }
}
