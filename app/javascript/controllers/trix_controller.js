import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "editor", "input" ]
  }

  connect() {
    this.setup()

    this.timer
    this.waitTime = 1000

    var Trix  = require("trix")

    Trix.config.textAttributes.underline = {
      style: { "textDecoration": "underline" },
      inheritable: true,
      parser: function(element) {
        var style = window.getComputedStyle(element);
        return style.textDecoration === "underline";
      }
    }
  }

  setup() {
    if(this.inputTarget.dataset.untouchedValue != null) {
      this.editorTarget.innerHTML = this.inputTarget.dataset.untouchedValue
    }

    this.addUnderlineButton()
  }

  addUnderlineButton() {
    const new_button = document.createElement('button')
    new_button.classList = 'trix-button underline'
    new_button.dataset.trixAttribute = "underline"
    new_button.title = "underline"
    new_button.innerText = "U"
    const groupElement = this.element.querySelector(".trix-button-group--text-tools")
    groupElement.insertBefore(new_button, groupElement.childNodes[4])
  }

  update(e) {
    this.updateStatusMessage("Updating...")

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      this.inputTarget.value = this.editorTarget.innerHTML
      this.editorTarget.closest('form').querySelector('.hidden-submit').click()
    }, this.waitTime);
  }

  showToolbar() {
    this.element.querySelector('.trix-button-row').style.opacity = '1'
  }

  hideToolbar(e) {
    this.element.querySelector('.trix-button-row').style.opacity = '0.5'
    this.element.querySelectorAll('.trix-button.trix-active').forEach((button) => {
      button.classList.remove('trix-active')
      button.click()
    })
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

