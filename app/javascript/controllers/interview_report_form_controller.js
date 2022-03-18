import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "analytics", 'answers' ]
  }

  // showTogglable() {
  //   this.togglableTarget.classList.remove('d-none')
  // }
  //
  // hideTogglable() {
  //   this.togglableTarget.classList.add('d-none')
  // }

  toggle() {
    if (this.analyticsTarget.classList.contains('d-none')) {
      this.analyticsTarget.classList.remove('d-nome')
      this.answersTarget.classList.add('d-none')
    } else if (this.answersTarget.classList.contains('d-none')) {
      this.answersTarget.classList.remove('d-none')
      this.analyticsTarget.classList.add('d-nome')
    }
  }
}
