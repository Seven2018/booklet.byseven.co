import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ 'tabContainer' ]
  }

  selectTab() {
    const container = this.tabContainerTarget
    const selected_tab = event.currentTarget.id.split('_')[1]

    container.querySelector('.booklet-tab-control.active').classList.remove('active')
    container.querySelectorAll('.booklet-tab').forEach((tab) => { tab.classList.add('hidden') })

    event.currentTarget.classList.add('active')
    container.querySelector('#tab_' + selected_tab).classList.remove('hidden')
  }
}
