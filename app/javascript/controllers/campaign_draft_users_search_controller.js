import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static get targets () {
    return [ "search", "results" ]
  }
  search() {
    const url = `${this.searchTarget.dataset.path}?search=${this.searchTarget.value}`
    fetch(url)
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
      })
  }
}
