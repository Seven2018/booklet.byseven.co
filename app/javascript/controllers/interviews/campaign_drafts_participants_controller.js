import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['directManagerText', 'interviewerText', 'requiredInput']
  }

  connect() {
    this.submit_button = document.getElementById('submit-button')

    if (this.element.dataset.defaultInterviewer == '') {
      this.submit_button.disabled = true
      this.submit_button.classList.add('disabled')
    }
  }

  chooseDirectManagerText(event) {
    this.directManagerTextTarget.classList.remove('d-none')
    this.directManagerTextTarget.classList.add('d-block')
    this.interviewerTextTarget.classList.remove('d-block')
    this.interviewerTextTarget.classList.add('d-none')
  }

  choseInterviewerText(event) {
    this.interviewerTextTarget.classList.remove('d-none')
    this.interviewerTextTarget.classList.add('d-block')
    this.directManagerTextTarget.classList.remove('d-block')
    this.directManagerTextTarget.classList.add('d-none')
  }

  enableSubmit(event) {
    if (event.type == 'keydown' && ![8,46].includes(event.keyCode)) {
      return
    }

    var enable = true
    this.requiredInputTargets.forEach((input) => {
      if (input.querySelector('input[type="hidden"]').value == '') { enable = false }
    })

    if (enable) {
      this.submit_button.disabled = false
      this.submit_button.classList.remove('disabled')
    } else {
      this.submit_button.disabled = true
      this.submit_button.classList.add('disabled')
    }
  }
}
