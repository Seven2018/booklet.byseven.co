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


  selectSubmit(e) {
    this.updateStatusMessage("Updating...")

    const element = e.currentTarget
    const attribute = element.dataset.attribute
    const form = element.closest('form')
    const selected_display = element.closest('.booklet-select__template-edit-container').querySelector('.booklet-select__template-edit-selected')
    const selected_value = element.querySelector('p').innerText
    const storage = form.querySelector('#interview_form_' + attribute)

    storage.value = selected_value.toLowerCase()
    selected_display.innerText = selected_value

    this.checkCrossAvailability(storage)
  }

  checkCrossAvailability(element) {
    const form = element.closest('form')
    const cross_toggle = form.querySelector('#template-edit__settings-cross-toggle')
    const cross_toggle_input = cross_toggle.querySelector('input')
    const input_value = element.value
    const submit_button = form.querySelector('.hidden-submit')

    if (input_value == 'both') {
      cross_toggle_input.disabled = false
    } else {
      if (cross_toggle_input.checked) { cross_toggle_input.checked = false; this.switchSide(cross_toggle_input, false) }
      cross_toggle_input.disabled = true
    }
    submit_button.click()
  }


  ///////////////////////
  // ADD QUESTION MENU //
  ///////////////////////

  showQuestionMenu(e) {
    console.log('start')

    if (!this.doubleClickGuardian) {
      const container = e.target.closest('.template-edit__add-question-btn')

      this.toggleQuestionMenuElements(container)
      setTimeout(() => this.doubleClickGuardian = true, 100)
    }
  }

  hideQuestionMenu() {
    if (this.doubleClickGuardian) {
      this.doubleClickGuardian = false
      const container = document.querySelector('.template-edit__add-question-btn.active')

      this.toggleQuestionMenuElements(container)
    }
  }

  toggleQuestionMenuElements(container) {
    const button_add = container.querySelector('.add_button_show')
    const button_remove = container.querySelector('.add_button_hide')
    const menu = container.querySelector('.template-edit__add-question-menu')

    container.classList.toggle('active')
    button_add.classList.toggle('hidden')
    button_remove.classList.toggle('hidden')
    menu.classList.toggle('hidden')
  }

  addQuestion(e) {
    const type = e.currentTarget.dataset.type
    const referenceNode = e.target.closest('.template-edit__add-question-btn')

    const newDiv = document.createElement("div")

    newDiv.classList.add('add-' + type)
    const template = document.querySelector('.add-' + type + '-template')
    const templateinfo = template.innerHTML
    newDiv.innerHTML = templateinfo
    newDiv.style.maxHeight = '100000px'
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

  //////////////////////
  // QUESTION OPTIONS //
  //////////////////////

  checkCustomCheckbox(e) {
    const element = e.currentTarget
    const checkbox = element.querySelector('input')
    const icon = element.querySelector('svg')

    if (checkbox.value == 'true') {
      checkbox.value = 'false'
      icon.classList.add('hidden')
    } else {
      checkbox.value = 'true'
      icon.classList.remove('hidden')
    }

    this.saveForm(e)
  }

  switchSide(e) {
    this.updateStatusMessage("Updating...")

    const element = e.currentTarget
    const save = element.dataset.save == 'true'
    const switch_button = element.parentNode
    const form = element.closest('form')
    const hidden_submit = form.querySelector('.hidden-submit')

    if (element.checked == true) {
      setTimeout(function(){switch_button.classList.add('switch_checked')}, 100)
    } else {
      setTimeout(function(){switch_button.classList.remove('switch_checked')}, 100)
    }
    if (hidden_submit != undefined && save) {
      hidden_submit.click();
    }
  }

  checkSwitchCompatibility(e) {
    const element = e.currentTarget
    const mode = element.dataset.mode

    if (this.doubleClickGuardian == false) {
      this.doubleClickGuardian = true
      setTimeout(function(){this.doubleClickGuardian = false}, 100)

      const question_card = element.closest('form')
      var element1 = question_card.querySelector('#interview_question_required_options-' + element.id.split('-')[1])
      var element2 = question_card.querySelector('#interview_question_visible_options-' + element.id.split('-')[1])

      if (element == element1 && element1.checked == true) {
        this.horizontalCompatibilityPair(element1, element2)
      } else if (element == element2 && element2.checked == false) {
        this.horizontalCompatibilityPair(element2, element1)
      }

      if (mode == 'visible_for') {
        const set = question_card.querySelectorAll('.interview_question_visible_options')
        const set_array = Array.from(set)
        element1 = element
        const index = set_array.indexOf(element1)
        if (index > -1) {
          set_array.splice(index, 1);
        }
        element2 = set_array[0]

        this.verticalCompatibilityPair(element1, element2)
      }

      this.switchSide(e)
    }
  }

  horizontalCompatibilityPair(element1, element2) {
    if (element1.checked) {
      element2.checked = true;
      setTimeout(function(){
        element2.parentNode.classList.add('switch_checked')
      }, 100)
    } else {
      element2.checked = false;
      setTimeout(function(){
        element2.parentNode.classList.remove('switch_checked')
      }, 100)
    }
  }

  verticalCompatibilityPair(element1, element2) {
    if (!element1.checked && !element2.checked) {
      element2.checked = true
      setTimeout(function(){element2.parentNode.classList.add('switch_checked')}, 100)
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

  toggleMod(e) {
    const element = e.currentTarget
    const caret = element.querySelector('i')
    var angle = parseInt(caret.getAttribute('data-rotated'), 10)

    caret.style.webkitTransform = 'rotate('+ (angle + 180).toString() +'deg)'
    caret.style.mozTransform    = 'rotate('+ (angle + 180).toString() +'deg)'
    caret.style.msTransform     = 'rotate('+ (angle + 180).toString() +'deg)'
    caret.style.oTransform      = 'rotate('+ (angle + 180).toString() +'deg)'
    caret.style.transform       = 'rotate('+ (angle + 180).toString() +'deg)'
    caret.setAttribute('data-rotated', (angle + 180).toString())

    const block = element.parentNode.parentNode
    const p = element.querySelector('p')
    const block_width = block.offsetWidth

    if (block.style.maxHeight == '64px' || block.style.maxHeight == '') {
      block.style.maxHeight = '100000px'
      p.style.maxHeight = '100000px'
      p.style.whiteSpace = 'normal'
      block.style.width = block_width.toString() + 'px'
      block.classList.add('active')
    } else if (block.style.maxHeight == '100000px') {
      block.style.maxHeight = '64px'
      p.style.maxHeight = '18px'
      p.style.whiteSpace = 'nowrap'
      block.style.width = 'auto'
      block.classList.remove('active')
    }
  }

}
