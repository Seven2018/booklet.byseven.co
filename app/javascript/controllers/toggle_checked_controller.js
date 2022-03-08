import { Controller } from "@hotwired/stimulus"
import { debounce } from "debounce"

export default class extends Controller {
  static get targets () {
    return [ "target", "togglable" ]
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

  debouncedToggle() {
    if (this.toggleDebounced) this.toggleDebounced.clear()
    this.toggleDebounced = debounce(this.toggle.bind(this), 10)
    this.toggleDebounced()
  }

  toggle() {
    if (this.togglableTarget.checked) {
      this.checkedClassesValue.split(' ').forEach((klass) => this.targetTarget.classList.add(klass))
      this.uncheckedClassesValue.split(' ').forEach((klass) => this.targetTarget.classList.remove(klass))
    }
    else {
      this.checkedClassesValue.split(' ').forEach((klass) => this.targetTarget.classList.remove(klass))
      this.uncheckedClassesValue.split(' ').forEach((klass) => this.targetTarget.classList.add(klass))
    }
  }

  dispatchToggleAll(e) {
    const event = new Event(this.toggleAllEventValue)
    window.dispatchEvent(event)
  }
}
