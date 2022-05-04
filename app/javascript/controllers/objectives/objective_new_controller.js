import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets () {
    return ['displayElement']
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
      } else {
        display.classList.add('d-none')
      }
    })
  }

}
