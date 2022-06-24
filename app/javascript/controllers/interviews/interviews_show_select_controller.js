import { useClickOutside } from 'stimulus-use'
import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['selectDisplay', 'selectMenu']
  }

  connect() {
    useClickOutside(this)
  }


  ////////////////////
  // BOOKLET SELECT //
  ////////////////////

  bookletSelectExpand(event) {
    this.selectMenuTarget.classList.toggle('hidden')
  }

  bookletSelectCollapse(event) {
    this.selectMenuTarget.classList.add('hidden')
  }

  bookletSelectSubmit(event) {
    const element = event.currentTarget
    const form = element.closest('form')
    const selected_display = element.closest('.booklet-select__container').querySelector('.booklet-select__selected')
    const selected_value = element.querySelector('p').innerText
    const storage = form.querySelector('#interview_answer_answer')
    const submit_button = form.querySelector('.hidden-submit')

    storage.value = selected_value
    selected_display.querySelector('p').innerText = selected_value
    submit_button.click()

    this.bookletSelectCollapse()
  }

  bookletSelectRemoveAnswer(event) {
    const element = event.currentTarget
    const form = element.closest('form')
    const selected_display = element.closest('.booklet-select__selected')
    const storage = form.querySelector('#interview_answer_answer')
    const submit_button = form.querySelector('.hidden-submit')

    selected_display.querySelector('p').innerText = ''
    element.classList.add('hidden')
    storage.value = ''
    submit_button.click()
  }


  //////////
  // MISC //
  //////////

  clickOutside(event) {
    this.bookletSelectCollapse()
  }
}
