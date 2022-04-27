import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return [ "editor", "input" ]
  }

  connect() {
    this.setup()

    this.timer
    this.waitTime = 1000
  }

  setup() {
    if(this.inputTarget.dataset.untouchedValue != null) {
      this.editorTarget.innerHTML = this.inputTarget.dataset.untouchedValue
    }
  }

  update(e) {
    updateStatusMessage("Updating...")

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      this.inputTarget.value = this.editorTarget.innerHTML
      this.editorTarget.closest('form').querySelector('.hidden-submit').click()
    }, this.waitTime);
  }


  //////////
  // MISC //
  //////////

  updateStatusMessage(message) {
    message_storage = document.getElementById('template-edit__update-status')
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

