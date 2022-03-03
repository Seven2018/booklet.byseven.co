import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "togglable" ]
  }
  static get values () {
    return {
      checkedClasses: String,
      uncheckedClasses: String,
      toggleAllEvent: String
    }
  }

  connect() {
    this.toggle()
  }

  toggle() {
    if (this.togglableTarget.checked) {
      this.checkedClassesValue.split(' ').forEach((klass) => this.element.classList.add(klass))
      this.uncheckedClassesValue.split(' ').forEach((klass) => this.element.classList.remove(klass))
    }
    else {
      this.checkedClassesValue.split(' ').forEach((klass) => this.element.classList.remove(klass))
      this.uncheckedClassesValue.split(' ').forEach((klass) => this.element.classList.add(klass))
    }
  }

  dispatchToggleAll(e) {
    const event = new Event(this.toggleAllEventValue)
    window.dispatchEvent(event)
  }
}
