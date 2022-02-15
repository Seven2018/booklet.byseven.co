import { Controller } from "@hotwired/stimulus"

const key = 'bookletCampaignsSearches'
const currentSearch = () => window.localStorage.getItem(key)

export default class extends Controller {
  static get targets () {
    return [ "search", "submit" ]
  }

  connect() {
    this.searchTarget.value = currentSearch()
    this.submitTarget.click()
  }

  storeSearch() {
    window.localStorage.setItem(key, this.searchTarget.value)
  }
}
