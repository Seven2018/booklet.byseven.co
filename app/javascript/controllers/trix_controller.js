import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "editor", "input" ]
  }

  connect() {
    this.setup()
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
    if (typeof saving !== 'undefined') {
      saving = false
      if (!saving) {
        saving = true
        // TODO stop faking :/
        setTimeout(function(){ saving = false }, 1000)
      }
    }
    this.inputTarget.value = this.editorTarget.innerHTML
    this.editorTarget.closest('form').querySelector('.hidden-submit').click()
  }
}
