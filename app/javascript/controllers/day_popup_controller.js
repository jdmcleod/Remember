import { Controller } from '@hotwired/stimulus'
import { animate, setElementLocation, toggleVisible } from '../helpers/dom_helpers'
import { get } from '@rails/request.js'

export default class DayPopupController extends Controller {
  static targets = ['popup', 'container']

  async show(event) {
    this.dayElement = event.target.closest('.day')
    const date = this.dayElement.dataset.date
    await this._loadContent(date)
    this._addEventListeners()
  }

  popupTargetConnected() {
    if (this.dayElement) this._movePopup()
  }

  // disconnect() {
  //   this._removeEventListeners()
  // }

  async _loadContent(date) {
    const response = await get(`/entries/day_popup_form/${date}`, { responseKind: 'turbo-stream' })
    if (response.ok) {
      console.log('it worked!')
    } else {
      console.log('it did not work')
    }
  }

  _movePopup() {
    this._setPosition()
    animate(this.popupTarget, 'zoomIn')
  }

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
    const clickOutsideNoteContainer = !target.closest('#day-popup-form')
    const isVisible = !this.element.classList.contains('visibility-hidden')

    if (clickOutsideNoteContainer && isVisible) this.close()
  }

  close() {
    animate(this.popupTarget, 'zoomOut')
    setTimeout(() => {
      toggleVisible(this.popupTarget, false)
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
    let { x, y } = this.dayElement.getBoundingClientRect()

    // if (x + this.popupTarget.clientWidth > document.body.clientWidth) x = x - this.popupTarget.clientWidth
    // if (y + this.popupTarget.clientHeight > document.body.clientHeight) y   = y - this.popupTarget.clientHeight

    setElementLocation(this.popupTarget, x, y)
  }
}
