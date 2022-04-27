import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return []
  }

  connect() {
    this.doubleClickGuardian = false
    this.opened_message = false
    this.saving = false
    this.timer
    this.waitTime = 1000

    this.element[
      (str => {
        return str
          .split('--')
          .slice(-1)[0]
          .split(/[-_]/)
          .map(w => w.replace(/./, m => m.toUpperCase()))
          .join('')
          .replace(/^\w/, c => c.toLowerCase())
      })(this.identifier)
    ] = this

    this.setup()
  }

  setup() {
    function OnInput() {
      this.style.height = "auto";
      this.style.height = (this.scrollHeight) + "px";
    }

    const tx = document.getElementsByTagName("textarea");
    for (let i = 0; i < tx.length; i++) {
      tx[i].setAttribute("style", "height:auto;overflow-y:hidden;");
      tx[i].addEventListener("click", OnInput, false);
      tx[i].addEventListener("input", OnInput, false);
      tx[i].click()
    }
  }


  ///////////////
  // SAVE FORM //
  ///////////////

  saveForm(e) {
    this.updateStatusMessage("Updating...")
    const form = e.target.closest('form')

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      form.querySelector('.hidden-submit').click()
    }, this.waitTime);
  }

  checkVideoCompatibility(e) {
    var video_link = e.target.value

    if (video_link.split('=')[0].replace("https://", "") == 'www.youtube.com/watch?v' || video_link == '') {
      e.target.style.color = '#333333'
      this.saveForm(e)
    } else {
      this.updateStatusMessage("Update failed")
      e.target.style.color = '#FF5656'
    }
  }


  ///////////////////////
  // TEMPLATE SETTINGS //
  ///////////////////////

  // function BookletSelectExpand(element) {
  //   doubleClickGuardian = true
  //   dropdown = element.closest('.booklet-select__template-edit-container').querySelector('.booklet-select__template-edit-dropdown')
  //   setTimeout(() => {
  //     doubleClickGuardian = false
  //   }, 100);
  //   if (dropdown.classList.contains('hidden')) {
  //     dropdown.classList.remove('hidden')
  //     window.addEventListener('click', function(e) {
  //       if (!doubleClickGuardian) {
  //         dropdown.classList.add('hidden')
  //         this.removeEventListener('click', arguments.callee, false);
  //       }
  //     });
  //   } else {
  //     dropdown.classList.add('hidden')
  //   }
  // }

  // function BookletSelectSubmit(element, attribute) {
  //   updateStatusMessage("Updating...")
  //   form = element.closest('form')
  //   container = element.closest('.booklet-select__template-edit-container')
  //   selected_display = element.closest('.booklet-select__template-edit-container').querySelector('.booklet-select__template-edit-selected')
  //   selected_value = element.querySelector('p').innerText
  //   storage = form.querySelector('#interview_form_' + attribute)
  //   submit_button = form.querySelector('.hidden-submit')

  //   storage.value = selected_value.toLowerCase()
  //   selected_display.innerText = selected_value

  //   checkCrossAvailability(storage)
  // }

  // function checkCrossAvailability(element) {
  //   form = element.closest('form')
  //   cross_toggle = form.querySelector('#template-edit__settings-cross-toggle')
  //   cross_toggle_input = cross_toggle.querySelector('input')
  //   input_value = element.value
  //   submit_button = form.querySelector('.hidden-submit')

  //   if (input_value == 'both') {
  //     cross_toggle_input.disabled = false
  //   } else {
  //     if (cross_toggle_input.checked) { cross_toggle_input.checked = false; switchSide(cross_toggle_input, false) }
  //     cross_toggle_input.disabled = true
  //   }
  //   submit_button.click()
  // }


  ///////////////////////
  // ADD QUESTION MENU //
  ///////////////////////

  addQuestionMenu(e) {
    if (doubleClickGuardian == false) {
      doubleClickGuardian = true
      const container = e.target.closest('.template-edit__add-question-btn')
      const button_add = e.target
      const button_remove = container.querySelector('.add_button_hide')
      const menu = container.querySelector('.template-edit__add-question-menu')

      container.classList.add('active')
      button_add.classList.add('hidden')
      button_remove.classList.remove('hidden')
      menu.classList.remove('hidden')

      function closeMenu(event) {
        if (doubleClickGuardian == false) {
          container.classList.remove('active')
          button_add.classList.remove('hidden')
          button_remove.classList.add('hidden')
          menu.classList.add('hidden')
          window.removeEventListener('click', closeMenu)
        }
      }

      window.addEventListener('click', closeMenu);

      setTimeout(function(){doubleClickGuardian = false}, 100)
    }
  }

  addQuestion(e) {
    const type = e.currentTarget.dataset.type
    const referenceNode = e.target.closest('.template-edit__add-question-btn')

    const newDiv = document.createElement("div")

    newDiv.classList.add('add-' + type)
    const template = document.querySelector('.add-' + type + '-template')
    const templateinfo = template.innerHTML
    newDiv.innerHTML = templateinfo
    const position = referenceNode.id.split('-')[1]
    const position_storage = newDiv.querySelector('#interview_question_position')

    position_storage.value = position
    const content = document.querySelector('#template-show__lines')
    if (position == 0) {
      content.insertBefore(newDiv, content.firstChild)
    } else {
      content.insertBefore(newDiv, referenceNode.nextSibling)
    }
  }


  /////////////////////
  // INFO MESSAGE //
  /////////////////////

  displayMessage(e) {
    const message_storage = e.target.parentNode.querySelector('.message-container')

    message_storage.classList.remove('hidden')

    setTimeout(function(){
      message_storage.classList.add('hidden')
    }, 3000)
  }


  //////////
  // MISC //
  //////////

  updateStatusMessage(message) {
    const message_storage = document.getElementById('template-edit__update-status')

    if (message_storage == undefined) return

    if (message == 'Up to date') {
      message_storage.classList.remove('bkt-red')
      message_storage.classList.remove('bkt-yellow')
      message_storage.classList.add('bkt-green')
    } else if (message == 'Update failed') {
      message_storage.classList.remove('bkt-green')
      message_storage.classList.remove('bkt-yellow')
      message_storage.classList.add('bkt-red')
    } else {
      message_storage.classList.remove('bkt-green')
      message_storage.classList.remove('bkt-red')
      message_storage.classList.add('bkt-yellow')
    }

    message_storage.innerText = message
  }
}
