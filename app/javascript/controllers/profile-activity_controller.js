import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['panel', 'typeList', 'profileInput']
  }

  displayList(e) {
    this.panelTarget.classList.toggle('d-none')
    this.typeListTargets.forEach((item) => {
      if (e.target.dataset.id == item.id) item.classList.add('d-block')
      else item.classList.remove('d-block')
    })
  }

  hideList() {
    this.panelTarget.classList.toggle('d-none')
    this.typeListTargets.forEach((item) => {
      item.classList.remove('d-block')
    })
  }

  displayOptions() {
    this.panelTarget.classList.toggle('d-none')
    this.typeListTargets.forEach((item) => {
      if (item.id == 'profile-options') item.classList.add('d-block')
    })
  }

  editable() {
    this.profileInputTargets.forEach(item => {
      item.disabled = !item.disabled
    })
    this.hideList()
  }
}
