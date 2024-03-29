import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ ]
  }

  select(e){
    document.querySelector('#customAccessLevelIntField').value = e.currentTarget.dataset.interviewReportParam

    JSON.parse(e.currentTarget.dataset.cans).forEach((can) => {
      const label = document.querySelector(`[data-label-for='user[${can}]']`)
      const input = document.querySelector(`input[id='user[${can}]']`)
      if (!input.checked) { label.parentNode.click() }
    })

    JSON.parse(e.currentTarget.dataset.cants).forEach((cant) => {
      const label = document.querySelector(`[data-label-for='user[${cant}]']`)
      const input = document.querySelector(`input[id='user[${cant}]']`)
      if (input.checked) { label.parentNode.click() }
    })
  }
}
