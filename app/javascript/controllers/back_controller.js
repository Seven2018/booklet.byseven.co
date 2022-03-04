import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  back () {
    if (document.referrer !== undefined) {
      window.history.back()
    } else {
      window.location.href = this.element.dataset.fallback
    }
  }
}
