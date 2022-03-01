import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

  static get targets () {
    return [ "array" ]
  }

  store(e) {
    const input = e.currentTarget.querySelector('input')
    input.checked ? this._add(id) : this._remove(id)
  }

  _add(id) {
    const array = this.arrayTarget.value.split(',')
    array.push(id)
    this.arrayTarget.value = array.join(',')
  }

  _remove(id){
    const array = this.arrayTarget.value.split(',')
    const index = array.indexOf(id);
    if (index > -1) { array.splice(index, 1); }
    this.arrayTarget.value = array.join(',')
  }
}
