import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['selectedTags', 'tagContainer']
  }

  connect() {
    this.color = this.element.dataset.color
    this.background_color = this.element.dataset.backgroundColor
  }

  selectTag(e) {
    const pill = e.currentTarget
    const pill_id = pill.dataset.id
    const checkbox = pill.querySelector('input')
    const storage_array = this.selectedTagsTarget.value.split(',')

    checkbox.checked = !checkbox.checked

    if (checkbox.checked) {
      storage_array.push(pill_id)
      pill.classList.remove('bkt-dark-grey', 'bkt-bg-light-grey8')
      pill.classList.add(this.color, this.background_color)
    } else {
      const index = storage_array.indexOf(pill_id);
      if (index > -1) {
        storage_array.splice(index, 1);
      }
      pill.classList.remove(this.color, this.background_color)
      pill.classList.add('bkt-dark-grey', 'bkt-bg-light-grey8')
    }

    this.selectedTagsTarget.value = storage_array.filter(Boolean)
    this.element.querySelector('.btn-search').click()

    this.blockEvents()
  }

  ///////////
  // TOOLS //
  ///////////

  blockEvents() {
    document.getElementById('bkt-blockDiv').classList.toggle('d-none')
    document.querySelector('body').classList.toggle('wait')
  }
}
