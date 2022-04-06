import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['tagList', 'displayZone'];
  }

  connect() {
    this.allTags = this.element.dataset.allTags.split(',').filter(value => value ? true : false)

    $(window).click(() => this.tagListTarget.classList.add('d-none'));
    $(this.displayZoneTarget).click(event => event.stopPropagation());
  }

  addTag(e) {
    const tag = e.target.innerText.trim()

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const div = document.createElement('div');
        div.className = 'tags d-inline-block bkt-bg-light-blue p-3 mx-2 font-weight-600 rounded-2px'
        div.innerHTML = `<div class="d-flex align-items-center"><div class="tag-value">${tag}</div> <div class="pl-2" data-action="click->tag-management#remove">x</div></div>`

        this.displayZoneTarget.prepend(div)
        if (e.target.dataset.create) {
          e.target.parentElement.remove()
        } else {
          e.target.remove()
        }
        const input = document.querySelector('.tag-input')
        input.value = ''
        input.focus()
      }
    })
  }

  displayList() {
    this.tagListTarget.classList.remove('d-none')
  }

  escape(event) {
    if (event.key === 'Escape') this.tagListTarget.classList.add('d-none')
    else this.tagListTarget.classList.remove('d-none')
  }

  filter(e) {
    const value = e.key == 'Backspace' ? '' : e.target.value
    const formTags = Array.from(document.querySelectorAll('.tag-value')).map(el => el.innerText)
    const createTag = !formTags.includes(value) ? value : null

    const toPrint = this.allTags.filter(tag => {
      const regex = new RegExp(value, 'g');
      return !!tag.match(regex) && !formTags.includes(tag)
    })
    this.updateSuggestionList(toPrint, createTag)
  }

  updateSuggestionList(arr, createTag) {
    this.tagListTarget.innerHTML = '<div class="d-flex m-4 bkt-light-grey">Select a tag or create new one</div>'
    arr.forEach(tag => {
      this.tagListTarget.innerHTML += `<div data-action="click->tag-management#addTag" class="d-flex align-items-center bkt-bg-light-grey-hover"> <div class="bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${tag}</div> </div>`
    })

    if (createTag) {
      console.log(createTag)
      const div = document.createElement('div')
      div.className = 'd-flex align-items-center bkt-bg-light-grey-hover'
      div.innerHTML = `<p class="ml-4 fs-1_2rem">Create</p> <div data-action="click->tag-management#addTag" data-create="tag" class="bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${createTag}</div>`

      this.tagListTarget.append(div)
    }
  }

  remove(e) {
    const tag = e.target.parentElement.querySelector('.tag-value').innerText.trim()

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const formTags = this.displayZoneTarget.querySelectorAll('.tags')
        formTags.forEach(div => {
          const formTag = div.firstChild.firstChild.textContent.trim()

          if (tag === formTag) div.remove()
        })
        this.tagListTarget.innerHTML += `<div data-action="click->tag-management#addTag" class="d-flex align-items-center bkt-bg-light-grey-hover"> <div class="bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${tag}</div> </div>`
      }
    })
  }

  toogleTag(tag, callback) {
    fetch(this.element.dataset.path, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({tag})
    })
      .then(callback)
  }
}