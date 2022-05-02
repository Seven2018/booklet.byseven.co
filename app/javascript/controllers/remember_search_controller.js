import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static get targets () {
    return [ "search", "dropdown", "submit" ]
  }
  static get values () {
    return {
      key: String
    }
  }

  connect() {
    if (this.hasSearchTarget && this.hasSubmitTarget) {
      this.searchTarget.value = this.currentSearch()
      this.submitTarget.click()
    }
  }

  storeSearch() {
    const searchbar = document.getElementById('searchbar');

    searchbar.querySelector('#search_page').value = '1'

    window.localStorage.setItem(this.keyValue, this.searchTarget.value)
  }

  currentSearch () {
    return window.localStorage.getItem(this.keyValue)
  }

  resetAllFilter(_) {
    const searchbar = document.getElementById('searchbar');
    const dropdowns = this.dropdownTargets

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

    // Reset custom dropdowns
    dropdowns.forEach((dropdown) => {
      const ps = dropdown.querySelectorAll('p')
      const display_container = ps[0]
      const default_value = ps[1]
      const value_storage = dropdown.querySelector("input[type='hidden']")

      display_container.innerText = default_value.innerText
      value_storage.value = default_value.dataset.value
    })

    // TODO : Unify all searches by tags
    try {
      // Reset Tags
      searchbar.querySelector('#search_tags').value = ''
      const filter_counter = searchbar.querySelectorAll('.searchbar-campaign-filter__selected')
      // pill_container = searchbar.querySelector('.searchbar-campaign__pill-container')
      filter_counter.forEach((counter) => {counter.innerText = '0'; counter.style.backgroundColor = '#C4C4C4'})
      // pill_container.querySelectorAll('.searchbar-campaign__pill:not(.hidden)').forEach((pill) => pill.remove())
    } catch {}

    // Reset offset
    searchbar.querySelector('#search_page').value = '1'

    searchbar.querySelector('.btn-search').click()
    document.querySelector('body').classList.add('wait')
    window.localStorage.setItem(this.keyValue, '')
  }
}
