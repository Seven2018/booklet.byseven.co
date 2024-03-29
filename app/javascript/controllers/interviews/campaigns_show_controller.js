import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ 'employeeCount', 'searchSubmit', 'addEmployeeModal', 'deadlineDisplay', 'tagContainer' ]
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

    this.setup()
  }

  setup(){
    if (this.element.dataset.campaignInCreation === 'true') {
      const button = document.getElementById('notifyAddParticipantsTrigger')
      button.click()
    }

    this.tagContainerTargets.forEach((target) => {
      this.hideOverflowingTags(target)
    })
  }

  ////////////
  // SEARCH //
  ////////////

  searchSubmit(event) {
    if (event.type == 'keyup') {

      clearTimeout(this.timer);

      this.timer = setTimeout(() => {
        this.searchSubmitTarget.click()
        document.querySelector('body').classList.add('wait')
      }, this.waitTime);

    } else {

      this.searchSubmitTarget.click()
      this.blockEvents()
    }
  }

  searchReset() {
    const searchbar = document.getElementById('searchbar-wrap')

    searchbar.querySelectorAll('input').forEach((input) => {
      input.value = ''
    })

    searchbar.querySelectorAll('.bkt-select-container').forEach((select) => {
      var display = select.querySelector('.bkt-select-display').firstElementChild
      var default_value = select.querySelector('.bkt-select-menu').firstElementChild.innerText

      display.innerText = default_value
      display.classList.remove('bkt-dark-grey')
    })

    this.searchSubmitTarget.click()
    this.blockEvents()
  }


  ///////////////////
  // EDIT DEADLINE //
  ///////////////////

  editDeadline(event) {
    const element = event.currentTarget
    const form = element.closest('form')

    this.deadlineDisplayTarget.innerText = element.value
    form.querySelector('.hidden-submit').click()
    document.querySelector('.modal.show').querySelector('.date-modal__close').click()
  }


  /////////////////////
  // REMOVE EMPLOYEE //
  /////////////////////

  removeEmployee(event) {
    const element = event.currentTarget
    const card = element.closest('.employee-card')

    const path = element.dataset.path
    const user_id = element.dataset.userId
    const url = `${path}?user_id=${user_id}`

    const modal_close = event.currentTarget.closest('.modal').querySelector('.close-button')

    modal_close.click()

    fetch(url, {
      method: 'DELETE',
      headers: {
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
          "Content-Type": "application/json"
        }
    }).then(response => {
      if (response.status == '200') {
        this.searchSubmitTarget.click()
        this.blockEvents()
      }
    })
  }

  ///////////
  // TOOLS //
  ///////////

  hideOverflowingTags(container) {
    const tags = container.querySelectorAll('.bkt-tag')
    const container_width = container.offsetWidth
    var result = 0
    var last_index = 0
    var tooltip_content = ''

    tags.forEach((tag, index) => {
      result += tag.offsetWidth
      tooltip_content += tag.innerText + '\n'
      if (result > (container_width - 50)) {
        tag.remove()
      } else {
        last_index = index
      }
    })

    if (result > (container_width - 50)) {
      var newDiv = document.createElement('div')
      newDiv.classList.add('mr-2', 'rounded-15px', 'py-1', 'px-3', 'font-weight-500', 'bkt-bg-light-blue', 'bkt-blue')
      newDiv.innerHTML = `<p class="fs-1_2rem">+${tags.length -(last_index + 1)}</p>`
      newDiv.setAttribute('data-toggle', 'tooltip');
      newDiv.setAttribute('title', tooltip_content)
      container.appendChild(newDiv)
    }
  }

  blockEvents() {
    document.getElementById('bkt-blockDiv').classList.toggle('d-none')
    document.querySelector('body').classList.toggle('wait')
  }
}
