import { Controller } from "@hotwired/stimulus"
import { debounce } from "debounce"

export default class extends Controller {
  static get targets () {
    return [ "search", "results", "selected" ]
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
    document.querySelector('body').classList.add('wait')

    const page = this.searchTarget.dataset.page // not currently used
    const mode = this.searchTarget.dataset.mode
    const startDate = document.querySelector('.search-inject-date-start') ?
      document.querySelector('.search-inject-date-start').value : null // is not a controller target to avoid dates dependencies
    const endDate = document.querySelector('.search-inject-date-end') ?
      document.querySelector('.search-inject-date-end').value : null // is not a controller target to avoid dates dependencies
    const selected = this.hasSelectedTarget ? this.selectedTarget.value : null
    const path = this.searchTarget.dataset.path
    const query = this.searchTarget.value
    const url = `${path}?search=${query}&page=${page}&mode=${mode}&start_date=${startDate}&end_date=${endDate}&selected=${selected}`
    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
        this._refreshFilteredCount()

        // Check the select filtered accordingly
        const select_filtered = document.getElementById('select_filtered')
        if (this.resultsTarget.childElementCount == 0
              || (this.resultsTarget.querySelectorAll('input[type="checkbox"]:not(:checked)').length > 0
              && select_filtered != undefined)) {
          select_filtered.querySelector('svg').classList.add('hidden')
          select_filtered.querySelector('input').checked = false
        } else {
          select_filtered.querySelector('svg').classList.remove('hidden')
          select_filtered.querySelector('input').checked = true
        }

        document.querySelector('body').classList.remove('wait')
      })
  }

  _refreshFilteredCount() {
    const event = new CustomEvent('refreshParticipantIdsFilteredCount')
    window.dispatchEvent(event)
  }
}
