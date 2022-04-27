import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "editor", "input" ]
  }

  connect() {
    this.setup()

    this.timer
    this.waitTime = 1000
  }

  setup() {
    if(this.inputTarget.dataset.untouchedValue != null) {
      this.editorTarget.innerHTML = this.inputTarget.dataset.untouchedValue
    }
  }

  update(e) {
    if(window.updateStatusMessage != undefined) {
      window.updateStatusMessage("Updating...")
    }

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      this.inputTarget.value = this.editorTarget.innerHTML
      this.editorTarget.closest('form').querySelector('.hidden-submit').click()
    }, this.waitTime);
  }
}
