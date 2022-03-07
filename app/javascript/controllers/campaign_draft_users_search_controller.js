import { Controller } from "@hotwired/stimulus"
import { debounce } from "debounce"

export default class extends Controller {
  static get targets () {
    return [ "search", "results" ]
  }
  connect() {
    this.search()
  }

  killEnter() {
    if (event.key == 'Enter') {
      event.stopPropagation()
      event.preventDefault()
    }
  }

  debouncedSearch() {
    if (this.searchDebounced) this.searchDebounced.clear()
    this.searchDebounced = debounce(this.search.bind(this), 500)
    this.searchDebounced()
  }

  search() {
    const page = this.searchTarget.dataset.page // not currently used
    const path = this.searchTarget.dataset.path
    const query = this.searchTarget.value
    const url = `${path}?search=${query}&page=${page}`
    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
        this._refreshFilteredCount()
      })
  }

  _refreshFilteredCount() {
    const event = new Event('refreshIntervieweeIdsFilteredCount')
    window.dispatchEvent(event)
  }
}
