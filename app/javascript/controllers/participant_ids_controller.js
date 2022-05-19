import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static get targets () {
    return [ 'array', 'selectedCount', 'results', 'result', 'filteredCount' ]
  }

  static get values () {
    return {
      path: String
    }
  }

  get ids() {
    return this.arrayTarget.value.split(',').filter(str => str.length > 0)
  }

  get inputIdsName() {
    return this.arrayTarget.name.substring(0, this.arrayTarget.name.length - 2)
  }

  connect() {
    this._refreshSelectedCount(this.ids.length)

    this.element[
      (str => {
        return str
          .split('--')
          .slice(-1)[0]
          .split(/[-_]/)
          .map(w => w.replace(/./, m => m.toUpperCase()))
          .join('')
          .replace(/^\w/, c => c.toLowerCase())
      })(this.identifier)
    ] = this
  }

  store(e) {
    if (this.arrayTarget.dataset.bulkOperationLock == 'true') return

    const id = e.currentTarget.dataset.id
    e.currentTarget.checked ? this._add(id) : this._remove(id)
  }

  storeRadio(e) {
    const id = e.currentTarget.dataset.id
    this._persist(id.toString())
  }

  unselectAll() {
    this._persist('', true)
  }

  selectAll() {
    this._persist('all', true)
  }

  selectFiltered(e) {
    this.arrayTarget.dataset.bulkOperationLock = true

    const checking = e.currentTarget.checked
      const checkboxes = [...this.resultTargets].filter(checkBox => checkBox.checked == !checking)
      const checkboxes_ids = checkboxes.map(checkBox => checkBox.dataset.id)
      checkboxes.forEach((checkBox) => {
        if (checking) {
          checkBox.parentNode.querySelector('svg').classList.remove('hidden')
        } else {
          checkBox.parentNode.querySelector('svg').classList.add('hidden')
        }
        // checkBox.click()
        checkBox.checked = checking
      })

      checking ? this._bulk_add(checkboxes_ids) : this._bulk_remove(checkboxes_ids)
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
      body: JSON.stringify({ [this.inputIdsName]: ids_string })
    })
    .then(response => response.json())
    .then(data => {
      if(refresh) { this._refreshForm() }
      this.arrayTarget.value = data[`${this.inputIdsName}_str`]
      this._refreshSelectedCount(data[`${this.inputIdsName}_count`])
    })
  }

  _refreshForm() {
    const event = new CustomEvent('refreshParticipantIdsSearch')
    window.dispatchEvent(event)
  }

  _refreshSelectedCount(count) {
    this.selectedCountTarget.innerText = count
  }

  refreshFilteredCount() {
    this.filteredCountTarget.innerText = `(${this.resultsTarget.childElementCount})`
  }

  blockEvents() {
    document.getElementById('bkt-blockDiv').classList.toggle('d-none')
    document.querySelector('body').classList.toggle('wait')
  }
}
