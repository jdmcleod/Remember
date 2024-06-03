import { Controller } from '@hotwired/stimulus'
import { animate, setElementLocation, toggleVisible } from '../helpers/dom_helpers'

export default class DayPopupController extends Controller {
  static targets = ['saveButton', 'form']

  connect() {
    this._initializeElement()
    this._addEventListeners()
  }

  disconnect() {
    this._removeEventListeners()
    this.element.remove()
  }

  _initializeElement() {
    this.element.classList.add('day-popup')
    this._setPosition()
    animate(this.element, 'zoomIn')
    toggleVisible(this.element, true)
  }

  get containerClass() { return '.day-popup' }
  selectedElement() { return this._selectedDiv ??= document.querySelector('.vis-item.vis-selected') }
  leftPanel() { return this._leftPanel ??= document.querySelector('.vis-panel.vis-left') }
  sidebar() { return this._sidebar ??= document.querySelector('.sidebar__content') }
  xOffset() { return 85 }
  yOffset() { return 35 }

  _removeEventListeners() {
    document.removeEventListener('mousedown', this._handleOutsideClick, true)
    document.removeEventListener('scroll', this._handleScroll, true)
    this._handleScroll = undefined
    this._handleOutsideClick = undefined
  }

  _addEventListeners() {
    if (!this._handleOutsideClick) {
      this._handleOutsideClick = (event) => this._onClick(event)
      document.addEventListener('mousedown', this._handleOutsideClick, true)
    }
  }

  _onClick(event) {
    this._handleClickOutsideDiv(event.target)
  }

  _handleClickOutsideDiv(target) {
    const clickOutsideNoteContainer = !target.closest(this.containerClass)
    const isVisible = !this.element.classList.contains('visibility-hidden')

    if (clickOutsideNoteContainer && isVisible) this.close()
  }

  close() {
    animate(this.element, 'zoomOut')
    setTimeout(() => {
      toggleVisible(this.element, false)
      this.disconnect()
    }, 500)
  }

  save() {
    setTimeout(() => {
      if (this.element.querySelector('#popup-form-saved')) {
        this.close()
      }
    }, 150)
  }

  _setPosition() {
    let { x, y } = this.selectedElement().getBoundingClientRect()

    const minXPosition = this.leftPanel().clientWidth + this.sidebar().clientWidth

    if (x < minXPosition) x = minXPosition
    if (x + this.element.clientWidth > document.body.clientWidth) x = x - this.element.clientWidth
    if (y + this.element.clientHeight > document.body.clientHeight) y   = y - this.element.clientHeight

    setElementLocation(this.element, x - this.xOffset(), y + this.yOffset())
  }
}
