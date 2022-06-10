import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['directManagerText', 'interviewerText']
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
}
