import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ 'reminderButton' ]
  }

  showReminderButton() {
    this.reminderButtonTarget.classList.remove('d-none')
  }

  hideReminderButton() {
    this.reminderButtonTarget.classList.add('d-none')
  }
}
