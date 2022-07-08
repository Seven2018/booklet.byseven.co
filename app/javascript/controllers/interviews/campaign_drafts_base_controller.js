import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['redirectUrlInput']
  }

  connect() {
    this.redirectUrlInputTarget.value = ''
  }

  submitAndRedirect(event) {
    const redirect_url = event.currentTarget.dataset.url
    const submit_button = document.querySelector('#submit-button')

    this.redirectUrlInputTarget.value = redirect_url

    if (submit_button == null || submit_button.disabled) {
      location.href = redirect_url;
    } else {
      this.redirectUrlInputTarget.value = redirect_url
      submit_button.click()
    }
  }
}
