import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ['singleTemplateContainer', 'multipleTemplateContainer']
  }

  chooseSingleTemplate() {
    this.multipleTemplateContainerTarget.classList.add('d-none')
    this.singleTemplateContainerTarget.classList.remove('d-none')
  }

  chooseMultipleTemplate() {
    this.singleTemplateContainerTarget.classList.add('d-none')
    this.multipleTemplateContainerTarget.classList.remove('d-none')
  }
}
