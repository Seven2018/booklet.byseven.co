import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return ['displayElement', 'multiChoiceContainer', 'multiChoiceTemplate',
            'selectedUsers', 'selectedUsersPillStorage', 'selectedUsersPillStorageModal',
            'selectedCount', 'filteredCount', 'selectAllButton', 'results']
  }

  static get values () {
    return {
      path: {type: String, default: '/objective/users'}
    }
  }

  connect() {
    this.doubleClickGuardian = false
    this.timer
    this.waitTime = 1000

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

    this.setup()
  }

  setup() {
    function OnInput() {
      this.style.height = "auto";
      this.style.height = (this.scrollHeight) + "px";
    }

    const tx = document.getElementsByTagName("textarea");
    for (let i = 0; i < tx.length; i++) {
      tx[i].setAttribute("style", "height:auto;overflow-y:hidden;");
      tx[i].addEventListener("click", OnInput, false);
      tx[i].addEventListener("input", OnInput, false);
      tx[i].click()
    }
  }


  //////////////////////////////////////////
  // OBJECTIVE INDICATOR SETTINGS DISPLAY //
  //////////////////////////////////////////

  display_settings(e) {
    const checkbox = e.currentTarget
    const target_displays = this.displayElementTargets

    target_displays.forEach((display) => {

      if (display.dataset.display == checkbox.dataset.target) {

        display.classList.remove('d-none')
        display.querySelectorAll('input').forEach((input) => {
          input.disabled = false
        })

      } else {

        display.classList.add('d-none')
        display.querySelectorAll('input').forEach((input) => {
          input.disabled = true
        })

      }

    })
  }


  //////////////////////////
  // MULTI-CHOICE OPTIONS //
  //////////////////////////

  addOption() {
    const template = this.multiChoiceTemplateTarget
    const newDiv = document.createElement("div")
    const container = this.multiChoiceContainerTarget

    newDiv.classList = template.classList
    newDiv.innerHTML = template.innerHTML

    const new_input = newDiv.querySelector('input')
    new_input.name = "indicator[options][choice_" + (container.querySelectorAll('input').length + 1).toString() + "]"

    container.appendChild(newDiv)
  }

  removeOption(e) {
    const option = e.currentTarget.parentNode

    option.remove()
  }


  //////////////////
  // MANAGE USERS //
  //////////////////

  get _selected_ids() {
    return this.selectedUsersTargets[0].value.split(',').filter(str => str.length > 0)
  }

  _update_storage(array) {
    this.selectedUsersTargets.forEach((target) => {
      target.value = array.join(',')
    })
  }

  refreshFilteredCount() {
    const filtered_count = this.resultsTarget.childElementCount

    this.filteredCountTarget.innerText = `(${filtered_count})`

    if (this.resultsTarget.querySelectorAll('input[type="checkbox"]:checked').length == filtered_count) {
      this.toggleSelectAllButton(true)
    }
  }

  refreshSelectedCount() {
    this.selectedCountTarget.innerText = `${this._selected_ids.length}`
  }

  toggleSelectAllButton(boolean) {
    this.selectAllButtonTarget.checked = boolean

    if (boolean) {
      this.selectAllButtonTarget.parentNode.classList.add('border-bkt-objective-blue-0_5px')
      this.selectAllButtonTarget.parentNode.classList.remove('border-bkt-light-grey5-0_5px')
      this.selectAllButtonTarget.parentNode.querySelector('svg').classList.remove('hidden')
    } else {
      this.selectAllButtonTarget.parentNode.classList.remove('border-bkt-objective-blue-0_5px')
      this.selectAllButtonTarget.parentNode.classList.add('border-bkt-light-grey5-0_5px')
      this.selectAllButtonTarget.parentNode.querySelector('svg').classList.add('hidden')
    }
  }

  selectAll(e) {
    const checkboxes = this.resultsTarget.querySelectorAll('input[type="checkbox"][data-id]')

    checkboxes.forEach((checkbox) => {
      if (checkbox.checked != e.currentTarget.checked) {
        checkbox.click()
      }
    })
  }

  storeUser(e) {
    var element = e.currentTarget
    const id = element.dataset.id

    if (element.dataset.type == 'pill') {
      element = document.querySelector(`input[data-id='${id}']`)
      element.click()
    }
    element.checked ? this._add(id, element) : this._remove(id, element)
  }

  _add(id, element) {
    const array = this._selected_ids
    array.push(id)
    this._update_storage(array)

    const newDivModal = document.createElement('div')
    const newDiv = document.createElement('div')
    const div_class_list = 'd-flex justify-content-between align-items-center height-2rem p-0_1rem m-0_5rem rounded-10px border-bkt-light-grey5 overflow-hidden'

    newDivModal.classList = div_class_list
    newDivModal.dataset.pill_id = id

    newDiv.classList = div_class_list
    newDiv.dataset.pill_id = id

    this.selectedUsersPillStorageModalTarget.appendChild(newDivModal)
    this.selectedUsersPillStorageTarget.appendChild(newDiv)

    const user_card = element.parentNode.parentNode
    const target_picture = user_card.querySelector('img')
    const target_name = element.dataset.name
    const pill_avatar = target_picture.cloneNode()
    const pill_name = document.createElement('p')
    const pill_button = document.createElement('p')
    pill_button.dataset.id = id

    pill_avatar.classList = 'avatar-xs'
    pill_name.classList = 'fs-1_2rem font-weight-500 px-0_75rem'
    pill_name.innerText = target_name
    pill_button.classList = 'fs-2_4rem bkt-light-grey cursor-pointer'
    pill_button.dataset.action = 'click->objectives--objective-new#storeUser'
    pill_button.dataset.type = 'pill'
    pill_button.innerHTML = '&times;'

    newDivModal.appendChild(pill_avatar)
    newDivModal.appendChild(pill_name)
    newDivModal.appendChild(pill_button)

    newDiv.appendChild(pill_avatar.cloneNode())
    newDiv.appendChild(pill_name.cloneNode(true))

    this.refreshSelectedCount()
  }

  _remove(id, element) {
    const array = this._selected_ids
    const index = array.indexOf(id);
    if (index > -1) { array.splice(index, 1); }
    this._update_storage(array)

    document.querySelectorAll(`[data-pill_id='${id}']`).forEach((pill) => {
      pill.remove()
    })

    this.refreshSelectedCount()
    this.toggleSelectAllButton(false)
  }
}
