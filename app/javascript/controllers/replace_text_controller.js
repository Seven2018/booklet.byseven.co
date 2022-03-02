import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static get targets () {
    return [ "replaceable" ]
  }

  replace(e) {
    this.replaceableTarget.textContent = e.currentTarget.textContent
  }
}
