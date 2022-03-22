import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "analytics", 'answers' ]
  }

  toggle(event) {
    if (event.target.dataset.interviewReportParam == 'data') {
      this.analyticsTarget.classList.add('d-none')
      this.answersTarget.classList.add('d-none')
    } else if (event.target.dataset.interviewReportParam == 'classic') {
      this.analyticsTarget.classList.remove('d-none')
      this.answersTarget.classList.add('d-none')
    } else if (event.target.dataset.interviewReportParam == 'answers') {
      this.answersTarget.classList.remove('d-none')
      this.analyticsTarget.classList.add('d-none')
    }
  }
}
