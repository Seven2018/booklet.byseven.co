import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static get targets () {
    return [ "search", "submit" ]
  }
  static get values () {
    return {
      key: String
    }
  }

  connect() {
    this.searchTarget.value = this.currentSearch()
    this.submitTarget.click()
  }

  storeSearch() {
    window.localStorage.setItem(this.keyValue, this.searchTarget.value)
  }

  currentSearch () {
    return window.localStorage.getItem(this.keyValue)
  }
}
