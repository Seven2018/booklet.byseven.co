import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['tagList', 'displayZone'];
  }

  connect() {
    super.connect();
    $(window).click(() => this.tagListTarget.classList.add('d-none'));
    this.formTags = ['hello', 'lol', 'harold']
    this.allTags = ['qwer', 'lal', 'toto', 'foo']
    this.updateHtml()
  }

  updateHtml() {
    $(this.displayZoneTarget).click(event => event.stopPropagation());
    this.formTags.forEach(tag => {
      const div = document.createElement('div');
      div.className = 'd-inline-block bkt-bg-light-blue p-3 mx-2 font-weight-600 rounded-2px'
      div.innerText = tag

      this.displayZoneTarget.prepend(div)
    })
    this.allTags.forEach(tag => {
      this.tagListTarget.innerHTML += `<div data-action="click->tag-management#addTag" class="d-flex align-items-center bkt-bg-light-grey-hover"> <div class="bkt-bg-light-blue p-3 m-2 font-weight-600 ml-4 rounded-2px">${tag}</div> </div>`
    })
  }

  addTag(e) {
    const div = document.createElement('div');
    div.className = 'd-inline-block bkt-bg-light-blue p-3 mx-2 font-weight-600 rounded-2px'
    div.innerText = e.target.innerText.trim()

    this.displayZoneTarget.prepend(div)
    e.target.remove()
    this.formTags.push(e.target.innerText.trim())
  }

  displayList() {
    this.tagListTarget.classList.remove('d-none')
  }
}