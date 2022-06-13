import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['requiredInput']
  }

  connect() {
    this.submit_button = document.getElementById('submit-button')
    this.submit_button.disabled = true
    this.submit_button.classList.add('disabled')
  }

  enableSubmit(event) {
    var enable = true
    if (this.requiredInputTarget.querySelector('input').value == '') { enable = false }

    if (enable) {
      this.submit_button.disabled = false
      this.submit_button.classList.remove('disabled')
    } else {
      this.submit_button.disabled = true
      this.submit_button.classList.add('disabled')
    }
  }
}
