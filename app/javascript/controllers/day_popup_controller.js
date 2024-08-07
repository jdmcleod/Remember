import { Controller } from '@hotwired/stimulus'
import { animate, setElementLocation, toggleVisible } from '../helpers/dom_helpers'
import { get } from '@rails/request.js'

const freeze = () => {
  // @ts-ignore
  window.Turbo.navigator.currentVisit.scrolled = true;
  document.removeEventListener("turbo:render", freeze);
};

const freezeScrollOnNextRender = () => {
  document.addEventListener("turbo:render", freeze);
};

export default class DayPopupController extends Controller {
  static targets = ['popup', 'container', 'form']

  async show(event) {
    if (this._popupOpen) {
      const date = this.dayElement.dataset.date
      await this._loadContent(date)
    }

    this._popupOpen = true
    this.dayElement = event.target.closest('.day')
    const date = this.dayElement.dataset.date
    await this._loadContent(date)
    this._addEventListeners()
  }

  popupTargetConnected() {
    if (this.dayElement) this._movePopup()
  }

  disconnect() {
    this._removeEventListeners()
  }

  async _loadContent(date) {
    await get(`/entries/day_popup_form/${date}`, { responseKind: 'turbo-stream' })
  }

  _movePopup() {
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
    if (target.closest('.day__wrapper')) return

    const clickOutsideNoteContainer = !target.closest('#day-popup-form')
    const isVisible = !this.element.classList.contains('visibility-hidden')

    if (clickOutsideNoteContainer && isVisible) this.close()
  }

  close() {
    animate(this.popupTarget, 'zoomOut')
    setTimeout(() => {
      this.save()
      toggleVisible(this.popupTarget, false)
      this.disconnect()
      this._popupOpen = false
    }, 150)
  }

  save() {
    if (this.formTarget) {
      freezeScrollOnNextRender()
      this.formTarget.requestSubmit()
    }
  }
}
