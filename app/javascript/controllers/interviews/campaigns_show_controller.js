import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ 'employeeCount' ]
  }

  connect() {

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
        card.remove()

        var count = parseInt(this.employeeCountTarget.innerText, 10)
        this.employeeCountTarget.innerText = count - 1
      }
    })
  }

  /////////////////////
}
