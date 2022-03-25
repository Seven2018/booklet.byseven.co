import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.center()
  }

  center() {
    this._path.style.transform = `translate(${this._xTransform}px, ${this._yTransform}px)`
  }

  get _path() { return this.element.querySelector('path') }
  get _bBox() { return this._path.getBBox() }

  get _viewBox() {
    let viewBox = {}
    let viewBoxKeys = ['minX', 'minY', 'width', 'height']
    let viewBoxValues = this.element.getAttribute('viewBox').split(' ')
    viewBoxKeys.forEach(function (value, i) { viewBox[value] = viewBoxValues[i] })
    return viewBox
  }

  get _yShould()    { return (this._viewBox.height - this._bBox.height) / 2 }
  get _yTransform() { return this._yShould - this._bBox.y }

  get _xShould()    { return (this._viewBox.width - this._bBox.width) / 2 }
  get _xTransform() { return this._xShould - this._bBox.x }
}
