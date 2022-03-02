import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static get targets () {
    return [ "array", 'selectedCount', 'results', 'filteredCount' ]
  }

  static get values () {
    return {
      path: String
    }
  }

  get ids() {
    return this.arrayTarget.value.split(',').filter(str => str.length > 0)
  }

  connect() {
    this._refreshSelectedCount(this.ids.length)
  }

  store(e) {
    if (this.arrayTarget.dataset.bulkOperationLock == 'true') return

    const id = e.currentTarget.dataset.userId
    e.currentTarget.checked ? this._add(id) : this._remove(id)
  }

  unselectAll() {
    this._persist('', true)
  }

  selectAll() {
    this._persist('all', true)
  }

  selectFiltered(e) {
    const results = this.resultsTarget.querySelectorAll('[data-user-id]')
    this.arrayTarget.dataset.bulkOperationLock = true

    const checking = e.currentTarget.checked
      const checkboxes = [...results].filter(checkBox => checkBox.checked == !checking)
      const checkboxes_ids = checkboxes.map(checkBox => checkBox.dataset.userId)
      checking ? this._bulk_add(checkboxes_ids) : this._bulk_remove(checkboxes_ids)
      checkboxes.forEach((checkBox) => {
        checkBox.click()
        checkBox.checked = checking
      })

    this.arrayTarget.dataset.bulkOperationLock = false
  }

  _bulk_add(ids) {
    const array = this.ids
    ids.forEach((id) => {
      array.push(id)
    })
    this._persist(array.join(','))
  }

  _bulk_remove(ids) {
    const array = this.ids
    ids.forEach((id) => {
      const index = array.indexOf(id);
      if (index > -1) { array.splice(index, 1); }
    })
    this._persist(array.join(','))
  }

  _add(id) {
    const array = this.ids
    array.push(id)
    this._persist(array.join(','))
  }

  _remove(id) {
    const array = this.ids
    const index = array.indexOf(id);
    if (index > -1) { array.splice(index, 1); }
    this._persist(array.join(','))
  }

  _persist(ids_string, refresh = false) {
    fetch(this.pathValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ interviewee_ids: ids_string })
    })
    .then(response => response.json())
    .then(data => {
      if(refresh) { this._refreshForm() }
      this.arrayTarget.value = data.interviewee_ids_str
      this._refreshSelectedCount(data.interviewee_ids_count)
    })
  }

  _refreshForm() {
    const event = new Event('refreshIntervieweeIdsSearch')
    window.dispatchEvent(event)
  }

  _refreshSelectedCount(count) {
    this.selectedCountTarget.innerText = count
  }

  refreshFilteredCount() {
    this.filteredCountTarget.innerText = `(${this.resultsTarget.childElementCount})`
  }
}
