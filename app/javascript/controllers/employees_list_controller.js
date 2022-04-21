import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['usersListOpt']
  }

  connect() {
    this.selectedUsers = []
  }

  toggleUser(event) {
    if (this.selectedUsers.includes(event.target.id)) {
      const idx = this.selectedUsers.indexOf(event.target.id)

      this.selectedUsers.splice(idx, 1)
    } else this.selectedUsers.push(event.target.id)

    // if (this.selectedUsers.length) {
    //   this.usersListOptTarget.classList.remove('d-none')
    //   this.usersListOptTarget.classList.add('d-block')
    // } else {
    //   this.usersListOptTarget.classList.remove('d-block')
    //   this.usersListOptTarget.classList.add('d-none')
    // }
  }
}
