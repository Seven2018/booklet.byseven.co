import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ ]
  }

  select(e){
    JSON.parse(e.currentTarget.dataset.cans).forEach((can) => {
      const label = document.querySelector(`[for='user[${can}]']`)
      const input = document.querySelector(`input[id='user[${can}]']`)
      if (!input.checked) { label.click() }
    })

    JSON.parse(e.currentTarget.dataset.cants).forEach((cant) => {
      const label = document.querySelector(`[for='user[${cant}]']`)
      const input = document.querySelector(`input[id='user[${cant}]']`)
      if (input.checked) { label.click() }
    })
  }
}
