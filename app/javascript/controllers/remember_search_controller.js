import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static get targets () {
    return [ "search", "submit" ]
  }
  static get values () {
    return {
      key: String
    }
  }

  connect() {
    this.searchTarget.value = this.currentSearch()
    this.submitTarget.click()
  }

  storeSearch() {
    window.localStorage.setItem(this.keyValue, this.searchTarget.value)
  }

  currentSearch () {
    return window.localStorage.getItem(this.keyValue)
  }

  resetAllFilter(_) {
    const searchbar = document.querySelector('.campaigns-index__searchbar');

    // Reset Search and Period input
    searchbar.querySelectorAll('input').forEach((input) => {
      if (input.type == 'text') {
        input.value = ''
      } else if (input.type == 'checkbox') {
        input.checked = false
      }
    })
    searchbar.querySelectorAll('select').forEach((select) => {
      select.selectedIndex = 0
    })

    // Reset Tags
    searchbar.querySelector('#search_tags').value = ''
    const filter_counter = searchbar.querySelectorAll('.searchbar-campaign-filter__selected')
    // pill_container = searchbar.querySelector('.searchbar-campaign__pill-container')
    filter_counter.forEach((counter) => {counter.innerText = '0'; counter.style.backgroundColor = '#C4C4C4'})
    // pill_container.querySelectorAll('.searchbar-campaign__pill:not(.hidden)').forEach((pill) => pill.remove())

    // Reset offset
    searchbar.querySelector('#search_page').value = '1'

    searchbar.querySelector('.btn-search').click()
    document.querySelector('body').classList.add('wait')
    window.localStorage.setItem(this.keyValue, '')
  }
}
