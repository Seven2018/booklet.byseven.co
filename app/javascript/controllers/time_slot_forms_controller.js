import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "container" ]
  }
  connect() {
    console.log('heya')
    // this.search()
  }

  create(e) {
    console.log('e.currentTarget',e.currentTarget)
    const container = e.currentTarget
    fetch(this.element.dataset.path, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "text/html"
      }
    })
    .then(response => response.text())
    .then(html => {
      container.insertAdjacentHTML('beforebegin', html)
      this._flatpickr()
    })
  }

  destroy(e) {
    const id = e.currentTarget.dataset.uuid
    document.querySelector(`#${id}`).remove()
  }

  _flatpickr() {
    const timepicker24s = document.querySelectorAll('.timepicker_24')
    timepicker24s.forEach((element) => {
      flatpickr(element, {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        time_24hr: true,
        defaultDate: element.dataset.defaultTime
      })
    })
    flatpickr(".datepicker_", { disableMobile: true })
  }
}
