import { useClickOutside } from 'stimulus-use'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return ['description', 'showDescriptionButton', 'updateModal', 'submitIndicatorButton', 'archiveButton', 'deleteButton']
  }

  connect() {
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

    // TOOLS //

    function OnInput() {
      if (this.tagName != 'TRIX-EDITOR') {
        this.style.height = "40px";
        this.style.height = (this.scrollHeight) + "px";
      }
    }

    function updateURLParameter(url, param, paramVal){
      var newAdditionalURL = "";
      var tempArray = url.split("?");
      var baseURL = tempArray[0];
      var additionalURL = tempArray[1];
      var temp = "";
      if (additionalURL) {
          tempArray = additionalURL.split("&");
          for (var i=0; i<tempArray.length; i++){
              if(tempArray[i].split('=')[0] != param){
                  newAdditionalURL += temp + tempArray[i];
                  temp = "&";
              }
          }
      }
      var rows_txt = temp + "" + param + "=" + paramVal;
      return baseURL + "?" + newAdditionalURL + rows_txt;
    }

    ///////////

    const tx = document.querySelectorAll("textarea, trix-editor");
    for (let i = 0; i < tx.length; i++) {
      tx[i].setAttribute("style", "height:auto;overflow-y:hidden;");
      tx[i].addEventListener("focus", OnInput, false);
      tx[i].addEventListener("input", OnInput, false);
    }

    const description = this.descriptionTarget.querySelector('div')
    const button = this.showDescriptionButtonTarget

    setTimeout(function() {
      if (description != null && description.scrollHeight > 80) {
        button.classList.remove('d-none')
      }
    }, 100)

    // Set up redirection for archive and delete functions

    const archive_button = this.archiveButtonTarget
    const delete_button = this.deleteButtonTarget

    delete_button.href = updateURLParameter(delete_button.href, 'redirected_from', document.referrer)
    archive_button.href = updateURLParameter(archive_button.href, 'redirected_from', document.referrer)
  }


  ////////////
  // HEADER //
  ////////////

  showDescription(event = null) {
    const button = event.currentTarget

    if (button.dataset.state == 'closed') {
      this.descriptionTarget.style.maxHeight = '1000000px'
      button.dataset.state = 'opened'
      button.innerText = 'See less'
    } else {
      this.descriptionTarget.style.maxHeight = '59px'
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
    const input = display.parentNode.querySelector('trix-editor') || display.parentNode.querySelector('input') || display.parentNode.querySelector('textarea')

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
    const input = display.parentNode.querySelector('trix-editor') || display.parentNode.querySelector('input') || display.parentNode.querySelector('textarea')

    if (edit_button.dataset.target == "objective-description") {
      this.showDescriptionButtonTarget.classList.add('d-none')
    }

    display.classList.add('d-none')
    input.classList.remove('d-none')
    input.tagName == 'INPUT' || input.tagName == 'TEXTAREA' ? this.setFocus(input) : input.focus()
  }

  expandInput(e) {
    const button = event.currentTarget

    if (button.dataset.state == 'closed') {
      this.descriptionTarget.style.maxHeight = '1000000px'
      button.dataset.state = 'opened'
    }
  }

  autoSave(e) {
    const form = e.currentTarget.closest('form')
    const submit_button = form.querySelector('.hidden-submit')

    submit_button.click()
  }


  //////////////////////
  // UPDATE INDICATOR //
  //////////////////////

  switchSide(e) {
    const element = e.currentTarget
    const switch_button = element.parentNode

    if (element.checked == true) {
      setTimeout(function(){switch_button.classList.add('switch_checked')}, 100)
    } else {
      setTimeout(function(){switch_button.classList.remove('switch_checked')}, 100)
    }
  }

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

  enableIndicatorSubmit(e) {
    const input = e.currentTarget
    const submit_button = this.submitIndicatorButtonTarget

    if (parseFloat(input.value, 10)) {
      submit_button.disabled = false
      submit_button.classList.remove('disabled')
    } else {
      submit_button.disabled = true
      submit_button.classList.add('disabled')
    }
  }


  ///////////
  // TOOLS //
  ///////////

  setFocus(elem) {
    var elemLen = elem.value.length;
    // For IE Only
    if (document.selection) {

        elem.focus();

        var oSel = document.selection.createRange();
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
    }
  }
}
