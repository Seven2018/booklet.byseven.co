import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return []
  }

  connect() {
    console.log('test')
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
  }


  ///////////////////
  // SAVE QUESTION //
  ///////////////////

  saveForm(e) {
    this.updateStatusMessage("Updating...")
    const form = e.target.closest('form')

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      form.querySelector('.hidden-submit').click()
    }, this.waitTime);
  }

  checkVideoCompatibility(e) {
    console.log('test')
    video_link = e.target.value

    if (video_link.split('=')[0].replace("https://", "") == 'www.youtube.com/watch?v' || video_link == '') {
      e.target.style.color = '#333333'
      saveForm(e.target)
    } else {
      this.updateStatusMessage("Update failed")
      e.target.style.color = '#FF5656'
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
    console.log(message)
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
