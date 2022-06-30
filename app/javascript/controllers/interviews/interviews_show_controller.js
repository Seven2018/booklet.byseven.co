import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return []
  }

  connect() {
    this.timer
    this.waitTime = 500

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
    const tx = document.getElementsByTagName("textarea");
    for (let i = 0; i < tx.length; i++) {
      tx[i].setAttribute("style", "height:auto;overflow-y:hidden;");
      tx[i].addEventListener("click", OnInput, false);
      tx[i].addEventListener("input", OnInput, false);
      // tx[i].click()
      OnInput(tx[i])
    }

    function OnInput(target = undefined) {

      if (target.target) {
        this.style.height = "auto";
        this.style.height = (this.scrollHeight) + "px";
      } else {
        target.style.height = "auto";
        target.style.height = (target.scrollHeight) + "px";
      }

    }
  }


  ///////////////////
  // SAVE QUESTION //
  ///////////////////

  autoSave(event) {
    this.updateStatusMessage("Updating...")
    const form = event.currentTarget.closest('form')

    clearTimeout(this.timer);

    this.timer = setTimeout(() => {
      form.querySelector('.hidden-submit').click()
    }, this.waitTime);
  }


  //////////////////////
  // SUBMIT INTERVIEW //
  //////////////////////

  enableSubmit() {
    const required_answers = document.querySelectorAll('#interview_answer_answer:required, #interview_answer_objective:required')
    const submit_buttons = document.querySelectorAll('#submit-interview')
    const link = document.getElementById('submit-interview-link')

    required_answers.forEach((input) => {
      if (input.value == '') {
        submit_buttons.forEach((button) => {
          button.classList.add('btn-blue-disabled')
          button.disabled = true
          link.href = ''
        })
        return
      }
    })
  }

  submit() {
    const submit_button = document.getElementById('submit-interview-link')

    submit_button.click()
  }


  //////////
  // MISC //
  //////////

  updateStatusMessage(message) {
    const message_storage = document.getElementById('xhr-form-status-btn')

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
