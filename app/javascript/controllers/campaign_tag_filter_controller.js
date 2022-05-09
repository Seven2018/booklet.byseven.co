import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['selectedTagsDom', 'unselectedTagsDom', 'tagList']
  }

  connect() {
    this.companyTags = this.element.dataset.companyTags.split(',').filter(item => !!item)
    this.selectedTags = []

    window.addEventListener('click', () => this.tagListTarget.classList.add('d-none'))
  }

  displayList(event) {
    event.stopPropagation()
    this.tagListTarget.classList.remove('d-none')
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  toggleTag(e) {
    const value = e.target.innerText.trim()

    if (this.companyTags.includes(value)) {
      this.selectedTags.push(value)
      this.request(this.selectedTags, async response => {
        eval(await response.text())
        const checkEmpty = this.selectedTagsDomTarget.innerText.trim()

        if (checkEmpty === 'Empty') this.selectedTagsDomTarget.innerHTML = ''
        this.selectedTagsDomTarget.append(e.target)
        this.companyTags = this.companyTags.filter(item => !(item === value))
      })
    } else {
      this.selectedTags = this.selectedTags.filter(item => !(item === value))
      this.request(this.selectedTags, async response => {
        eval(await response.text())
        const div = document.createElement('div')
        div.className = 'flex-row-start-centered bkt-placeholder-light-grey'

        div.append(e.target)
        this.unselectedTagsDomTarget.append(div)
        this.companyTags.push(value)
      })
    }
  }

  search(e) {
    const value = e.target.value.trim()

    const filtered = this.companyTags.filter(tag => {
      const regex = new RegExp(value, 'g');

      return !!tag.match(regex)
    })

    this.unselectedTagsDomTarget.innerHTML = ''
    filtered.forEach(tag => {
      const div = document.createElement('div')
      div.className = 'flex-row-start-centered bkt-placeholder-light-grey'
      div.innerHTML = `<button class="d-inline-block bkt-bg-light-blue p-3 m-2 font-weight-600 rounded-2px fs-1_2rem" data-action="click->campaign-tag-filter#toggleTag">${tag}</button>`
      this.unselectedTagsDomTarget.append(div)
    })
  }

  request(tags, callback) {
    fetch(this.element.dataset.path + '?' + (new URLSearchParams({
      'search[tags]': tags
    })), {
      method: "GET",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        'Accept': 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01',
        'X-Requested-With': 'XMLHttpRequest'
      },
    })
      .then(callback)
  }
}
