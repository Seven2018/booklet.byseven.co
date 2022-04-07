import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['tagList', 'displayZone', 'inputFilter'];
  }

  connect() {
    this.allTags = this.element.dataset.allTags.split(',').filter(value => value ? true : false)

    window.addEventListener('click', () => {
      this.tagListTarget.classList.add('d-none')
      document.querySelectorAll('.tag-suggestion-option').forEach(el => el.classList.add('d-none'))
    });
    $(this.displayZoneTarget).click(event => event.stopPropagation());
    this.inputFilterTarget.addEventListener('focus', _ => this.displayZoneTarget.classList.add('bkt-bg-light-grey8'))
    this.inputFilterTarget.addEventListener('focusout', _ => this.displayZoneTarget.classList.remove('bkt-bg-light-grey8'))
  }

  addTag(e) {
    const tag = e.target.innerText.trim()

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const buttonElement = document.createElement('button');
        buttonElement.className = 'tags d-inline-block bkt-bg-light-blue p-3 mx-2 font-weight-600 rounded-2px fs-1_2rem'
        buttonElement.innerHTML = `
          <div class="d-flex align-items-center">
            <div class="tag-value pl-2">${tag}
            </div> <div class="pl-2 opacity-0 opacity-1-hover" data-action="click->tag-management#remove">X</div>
          </div>`

        this.displayZoneTarget.prepend(buttonElement)
        if (e.target.dataset.create) {
          e.target.parentElement.remove()
          this.filter({target: {value: ''}})
        } else {
          e.target.remove()
        }

        this.inputFilterTarget.value = ''
        this.inputFilterTarget.placeholder = ''
        this.inputFilterTarget.focus()
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
    console.log('before event', e.target.value)
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
      this.tagListTarget.innerHTML += `<button data-action="click->tag-management#addTag" class="width-100 flex-row-start-centered align-items-center bkt-bg-light-grey-hover fs-1_2rem"> <div class="d-inline-block bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${tag}</div> </button>`
    })

    if (createTag) {
      const div = document.createElement('div')
      div.className = 'd-flex align-items-center bkt-bg-light-grey-hover'
      div.innerHTML = `<p class="ml-4 fs-1_2rem">Create</p> <button data-action="click->tag-management#addTag" data-create="tag" class="bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px fs-1_2rem">${createTag}</button>`

      this.tagListTarget.append(div)
    }
  }

  remove(e) {
    const tag = e.target.parentElement.querySelector('.tag-value').innerText.trim()

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const formTags = this.displayZoneTarget.querySelectorAll('.tag-value')
        console.log(formTags)
        formTags.forEach(div => {
          const formTag = div.textContent.trim()

          if (tag === formTag) div.parentElement.parentElement.remove()
        })
        this.tagListTarget.innerHTML += `<button data-action="click->tag-management#addTag" class="width-100 flex-row-start-centered align-items-center bkt-bg-light-grey-hover fs-1_2rem"> <div class="d-inline-block bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${tag}</div> </button>`
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

  showTagOptions(event) {
    event.stopPropagation()
    const div = event.target.parentElement.querySelector('div')

    if (div != null) div.classList.remove('d-none')
  }

  deleteTag(event) {
    event.stopPropagation()
    const tag = event.target.dataset.tagName.trim()

    // TODO: make request to remove then remove closest tag-company-item class
  }
}