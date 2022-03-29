import { Controller } from "@hotwired/stimulus"
import { debounce } from "debounce"

export default class extends Controller {
  static get targets () {
    return [ 'selectAllInput', 'tagCategoryInput', 'search', 'mode' ]
  }

  showTagCategoryInput() {
    this.tagCategoryInputTarget.classList.remove('d-none')
  }

  hideTagCategoryInput() {
    this.tagCategoryInputTarget.classList.add('d-none')
  }

  showSelectAllInput() {
    this.selectAllInputTarget.classList.remove('d-none')
  }

  hideSelectAllInput() {
    this.selectAllInputTarget.classList.add('d-none')
  }

  debouncedChangeSearchMode() {
    if (this.changeSearchModeDebounded) this.changeSearchModeDebounded.clear()
    this.changeSearchModeDebounded = debounce(this.changeSearchMode.bind(this), 10)
    this.changeSearchModeDebounded()
  }

  changeSearchMode() {
    this.modeTargets.forEach((label) => {
      const input = label.querySelector('input')
      if (input.checked) { this.searchTarget.dataset.mode = input.value }
    })
    this.application.getControllerForElementAndIdentifier(this.element, "search-inject").search()
  }

  dispatchFormUpdate() {
    const event = new Event('interview_report_form_toggle')
    window.dispatchEvent(event)
  }
}
