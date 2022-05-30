import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['autocompletInput']
  }

  triggerSearch (e) {
    var input = e.currentTarget
    console.log(input)
    const event = new Event('keyup',{ keycode: 'a' });

    input.focus()
    input.value = ''
    input.dispatchEvent(event)
  }
}
