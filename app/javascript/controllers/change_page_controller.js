import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static get targets () {
    return [ "pageInput", "submit" ]
  }

  connect() {
    setTimeout(this._setPaginationLinks, 1000)
  }

  previous() {
    this.pageInputTarget.value = (parseInt(this.pageInputTarget.value,10) - 1).toString()
    this._submit()
  }

  next() {
    this.pageInputTarget.value = (parseInt(this.pageInputTarget.value,10) + 1).toString()
    this._submit()
  }

  set(e) {
    this.pageInputTarget.value = e.currentTarget.innerText
    this._submit()
  }

  _submit() {
    this.submitTarget.click()
    setTimeout(this._setPaginationLinks, 1000)
  }

  _setPaginationLinks() {
    document.querySelectorAll('ul.pagination a').forEach((link) => {
      link.setAttribute('data-action', 'click->change-page#set')
    })
  }
}
