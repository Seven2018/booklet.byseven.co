import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['container'];
  }

  showScrollbar() {
    const container = this.containerTarget
    console.log(container)
    if(timer !== null) {
      clearTimeout(timer);
      console.log('coucou')
    }
    container.classList.remove('hide-scrollbar')
    var timer = setTimeout(function() {
      container.classList.add('hide-scrollbar')
    }, 1000);
  }
}
