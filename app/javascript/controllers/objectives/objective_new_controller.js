import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return ['displayElement', 'multiChoiceContainer', 'multiChoiceTemplate']
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


  //////////////////////////////////////////
  // OBJECTIVE INDICATOR SETTINGS DISPLAY //
  //////////////////////////////////////////

  display_settings(e) {
    const checkbox = e.currentTarget
    const target_displays = this.displayElementTargets

    target_displays.forEach((display) => {

      if (display.dataset.display == checkbox.dataset.target) {

        display.classList.remove('d-none')
        display.querySelectorAll('input').forEach((input) => {
          input.disabled = false
        })

      } else {

        display.classList.add('d-none')
        display.querySelectorAll('input').forEach((input) => {
          input.disabled = true
        })

      }

    })
  }


  //////////////////////////
  // MULTI-CHOICE OPTIONS //
  //////////////////////////

  addOption() {
    const template = this.multiChoiceTemplateTarget
    const newDiv = document.createElement("div")
    const container = this.multiChoiceContainerTarget

    newDiv.classList = template.classList
    newDiv.innerHTML = template.innerHTML

    const new_input = newDiv.querySelector('input')
    new_input.name = "indicator[options][choice_" + (container.querySelectorAll('input').length + 1).toString() + "]"

    container.appendChild(newDiv)
  }

  removeOption(e) {
    const option = e.currentTarget.parentNode

    option.remove()
  }

}
