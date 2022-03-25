import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "analytics", 'search' ]
  }

    showAnalytics() {
    this.analyticsTarget.classList.remove('d-none')
  }

  hideAnalytics() {
    this.analyticsTarget.classList.add('d-none')
  }

  changeSearchMode(e) {
    if (e.target.dataset.interviewReportParam) {
      this.searchTarget.dataset.mode = e.target.dataset.interviewReportParam
      // console.log(this.application.getControllerForElementAndIdentifier(this.element, "search-inject"))
      // console.log(this.identifier)
      // console.log(this.element)
      this.application.getControllerForElementAndIdentifier(this.element, "search-inject").search()
    }
  }
}
