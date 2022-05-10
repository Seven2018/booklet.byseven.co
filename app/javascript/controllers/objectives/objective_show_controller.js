import { useClickOutside } from 'stimulus-use'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return ['description', 'showDescriptionButton', 'updateModal']
  }

  connect() {
    this.doubleClickGuardian = false
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
    // function OnInput() {
    //   this.style.height = "auto";
    //   this.style.height = (this.scrollHeight) + "px";
    // }

    // const tx = document.getElementsByTagName("textarea");
    // for (let i = 0; i < tx.length; i++) {
    //   tx[i].setAttribute("style", "height:auto;overflow-y:hidden;");
    //   tx[i].addEventListener("click", OnInput, false);
    //   tx[i].addEventListener("input", OnInput, false);
    //   tx[i].click()
    // }

    // console.log(parseInt(this.descriptionTarget.parentNode.offsetHeight, 10) > 79)
    const description = this.descriptionTarget.querySelector('div')
    const button = this.showDescriptionButtonTarget

    setTimeout(function() {
      if (description != null && description.scrollHeight > 80) {
        button.classList.remove('d-none')
      }
    }, 100)
  }


  ////////////
  // HEADER //
  ////////////

  showDescription(e) {
    const button = e.currentTarget

    if (button.dataset.state == 'closed') {
      this.descriptionTarget.style.maxHeight = '1000000px'
      button.dataset.state = 'opened'
      button.innerText = 'See less'
    } else {
      this.descriptionTarget.style.maxHeight = '79px'
      button.dataset.state = 'closed'
      button.innerText = 'See all'
    }
  }


  /////////////////////////////////
  // UPDATE OBJECTIVE ATTRIBUTES //
  /////////////////////////////////

  showEditButton(e) {
    const attribute_div = e.currentTarget
    const edit_button = attribute_div.querySelector('.edit_button')
    const display = document.querySelector(`#${edit_button.dataset.target}`)
    const input = display.parentNode.querySelector('trix-editor') || display.parentNode.querySelector('input')

    if (edit_button.classList.contains('opacity_0') || input === document.activeElement) {
      attribute_div.classList.add('bkt-bg-light-grey9')
      edit_button.classList.remove('opacity_0')
    } else {
      attribute_div.classList.remove('bkt-bg-light-grey9')
      edit_button.classList.add('opacity_0')
    }
  }

  showInput(e) {
    const edit_button = e.currentTarget
    const display = document.querySelector(`#${edit_button.dataset.target}`)
    const input = display.parentNode.querySelector('trix-editor') || display.parentNode.querySelector('input')

    display.classList.add('d-none')
    input.classList.remove('d-none')
    input.tagName == 'INPUT' ? this.setFocus(input) : input.focus()
  }

  hideInput(e) {
    const input = e.currentTarget
    const display = input.parentNode.firstElementChild
    const attribute_div = display.closest('.input_container')

    attribute_div.classList.remove('bkt-bg-light-grey9')
    display.classList.remove('d-none')
    input.querySelector('trix-editor') == undefined ?
      input.classList.add('d-none') : input.querySelector('trix-editor').classList.add('d-none')
    // input.blur()

    document.querySelectorAll('.edit_button').forEach((button) => {
      button.classList.add('opacity_0')
    })
  }


  //////////////////////
  // UPDATE INDICATOR //
  //////////////////////

  selectOption(e) {
    const modal = e.currentTarget.closest('.modal')
    const input = e.currentTarget.querySelector('input')
    const radios = modal.querySelectorAll('input[type="radio"]')

    input.checked = true

    radios.forEach((radio) => {
      var label = radio.parentNode

      if (radio.checked) {
        label.classList.remove('bkt-bg-light-grey9', 'border-bkt-light-grey6', 'bkt-light-grey6')
        label.classList.add('bkt-bg-light-objective-blue', 'border-bkt-objective-blue-0_5px', 'bkt-objective-blue')
      } else {
        label.classList.add('bkt-bg-light-grey9', 'border-bkt-light-grey6', 'bkt-light-grey6')
        label.classList.remove('bkt-bg-light-objective-blue', 'border-bkt-objective-blue-0_5px', 'bkt-objective-blue')
      }
    })
  }

  updateCompletion(e) {
    const modal = e.currentTarget.closest('.modal')
    const submit_button = modal.querySelector('.hidden-submit')
    const close_button = modal.querySelector('.action-modal__close')

    submit_button.click()
    close_button.click()
  }


  ///////////
  // TOOLS //
  ///////////

  setFocus(elem) {
    var elemLen = elem.value.length;
    // For IE Only
    if (document.selection) {
        // Set focus
        elem.focus();
        // Use IE Ranges
        var oSel = document.selection.createRange();
        // Reset position to 0 & then set at end
        oSel.moveStart('character', -elemLen);
        oSel.moveStart('character', elemLen);
        oSel.moveEnd('character', 0);
        oSel.select();
    }
    else if (elem.selectionStart || elem.selectionStart == '0') {
        // Firefox/Chrome
        elem.selectionStart = elemLen;
        elem.selectionEnd = elemLen;
        elem.focus();
    } // if
  }
}
