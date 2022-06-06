import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['tagList', 'displayZone', 'inputFilter', 'modal', 'modalClose', 'modalConfirm'];
  }

  connect() {
    this.timer
    this.waitTime = 500

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
    const targetItemValue = e.target.classList.contains('tag-company-item') ? e.target : e.target.closest('.tag-company-item')
    const buttonTagName = targetItemValue.querySelector('.tag-company-item-value')
    const tag = buttonTagName.innerText

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const buttonElement = document.createElement('button');
        buttonElement.className = `tags d-flex align-items-center fs-1_2rem font-weight-600 ${this.element.dataset.color} ${this.element.dataset.background_color} px-1rem py-0_5rem mr-1rem mb-1rem rounded-15px width-fit-content`
        buttonElement.innerHTML = `<div class="tag-value">${tag}</div> <div class="fs-1_6rem pl-2 opacity_70pc opacity-hover_1" data-action="click->tag-management#remove">&times;</div>`

        this.displayZoneTarget.prepend(buttonElement)
        targetItemValue.remove()
        this.filter({target: {value: ''}})

        this.inputFilterTarget.value = ''
        this.inputFilterTarget.placeholder = ''
        this.inputFilterTarget.focus()

        this.updateTagList(response)
        this.updateCardTags()
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
    const value = e.target.value
    const formTags = Array.from(document.querySelectorAll('.tag-value')).map(el => el.innerText)

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      this.searchTags(value, toPrint => {
        console.log(toPrint)
        const displayed = Array.from(this.displayZoneTarget.querySelectorAll('.tag-value')).map(x => x.innerText.toLowerCase())

        const result_array = toPrint.categories == undefined ? toPrint : toPrint.categories

        const createTag = !result_array.includes(value) && !displayed.includes(value.toLowerCase()) ? value : null

        this.updateSuggestionList(result_array, createTag)
      })
    }, this.waitTime);
  }

  updateSuggestionList(arr, createTag) {
    this.tagListTarget.innerHTML = '<div class="d-flex m-4 bkt-light-grey">Select a tag or create new one</div>'
    arr.forEach(tag => {
      const suggestionItem = this.createSuggestionItem(tag)
      this.tagListTarget.append(suggestionItem)
    })

    if (createTag) {
      const div = document.createElement('div')
      div.className = 'tag-company-item d-flex align-items-center bkt-bg-light-grey-hover'
      div.innerHTML = `<p class="tag-company-item ml-4 fs-1_2rem">Create</p> <button data-action="click->tag-management#addTag" data-create="tag" class="tag-company-item-value d-flex align-items-center fs-1_2rem font-weight-600 bkt-dark-grey bkt-bg-light-grey8 px-1rem py-0_5rem m-1rem rounded-15px width-fit-content"><div class="tag-value">${createTag}</div></button>`

      this.tagListTarget.insertBefore(div, this.tagListTarget.firstElementChild.nextSibling)
    }
  }

  remove(e) {
    const tag = e.target.parentElement.querySelector('.tag-value').innerText.trim()

    this.toogleTag(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        const formTags = this.displayZoneTarget.querySelectorAll('.tag-value')

        formTags.forEach(div => {
          const formTag = div.innerText.trim()

          if (tag === formTag) {
            div.parentElement.remove()
            const suggestionItem = this.createSuggestionItem(tag)
            this.tagListTarget.append(suggestionItem)
          }
        })

        this.updateTagList(response)
        this.updateCardTags()
      }
    })

  }

  toogleTag(tag, callback) {
    fetch(this.element.dataset.togglePath, {
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

    const options = document.querySelectorAll('.company-tag-options')
    options.forEach(el => {
      if (div === el) div.classList.toggle('d-none')
      else el.classList.add('d-none')
    })
  }

  preparModal(event) {
    event.stopPropagation()
    const parent = event.target.closest('.tag-company-item')
    const tag = parent.dataset.tagName.trim()
    const id = parent.dataset.tagName.trim()

    this.modalTarget.classList.remove('hidden')
    this.modalConfirmTarget.dataset.tag = tag
    this.modalConfirmTarget.dataset.id = id
  }

  removeCompanyTagRequest(tag, callback) {
    const params = new URLSearchParams({tag})

    fetch(this.element.dataset.removeCompanyTagPath + '?' + params, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json"
      },
    })
      .then(callback)
  }

  makeRemoveCompanyTagRequest(event) {
    const tag = event.target.dataset.tag.trim()
    const id = event.target.dataset.id.trim()

    this.removeCompanyTagRequest(tag, response => {
      if (response.status >= 200 && response.status < 400) {
        document.querySelector(`#${id}`)
        this.modalTarget.classList.add('hidden')

        const suggestionItem = document.querySelectorAll('.tag-company-item')
        suggestionItem.forEach(div => {
          const suggestionTag = div.querySelector('.tag-company-item-value').innerText.trim()

          if (suggestionTag === tag) div.remove()
        })

        this.updateTagList(response)
        this.updateCardTags(true)
      }
    })
  }

  createSuggestionItem(tag) {
    const xmlString = `<div data-action="click->tag-management#addTag"
             class="tag-company-item width-100 flex-row-between-centered align-items-center bkt-bg-light-grey8-hover fs-1_2rem cursor-pointer"
             id="tag-suggestion-${Date.now()}"
             data-tag-name="${tag}"
        >
          <button class="tag-company-item-value d-flex align-items-center fs-1_2rem font-weight-600 bkt-dark-grey bkt-bg-light-grey8 px-0_75rem py-0_5rem m-1rem rounded-15px width-fit-content">${tag}</button>
          <div class="position-relative">
            <button class="p-2 rounded-2px bkt-bg-light-grey-hover mr-2" data-action="click->tag-management#showTagOptions">···</button>
            <div class="company-tag-options d-none position-absolute right-0 bkt-bg-white bkt-box-shadow-medium rounded-5px p-2 z-index-5 tag-suggestion-option">
              <button class="flex-row-between-centered" data-action="click->tag-management#preparModal" >
                <span class="iconify mr-1" data-icon="akar-icons:trash-can" ></span>
                <p class="fs-1_2rem bkt-dark-grey" >Delete</p>
              </button>
            </div>
          </div>
        </div>`;

    return new DOMParser().parseFromString(xmlString, "text/html").body;
  }

  searchTags(input, callback) {
    fetch(this.element.dataset.searchTagPath, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({input: input})
    })
      .then(response => response.json())
      .then(callback)
  }

  /////////////////////////
  // UPDATE TAGS DISPLAY //
  /////////////////////////

  updateTagList(response) {
    const tags_container = document.querySelector('#displayed-tags')

    if (tags_container != undefined) {
      const response_text = response.text()
      response_text.then(value => {
        tags_container.innerHTML = value
      })
    }
  }

  updateCardTags(all = false) {
    const modal = document.querySelector('.modal.show')
    var link = modal.querySelector('.update-line')

    if (all) {
      link = modal.querySelector('.update-list')
      modal.querySelector('.action-modal__close').click()
    }

    link.click()
  }
}

