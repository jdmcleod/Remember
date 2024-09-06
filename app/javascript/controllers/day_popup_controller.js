import { Controller } from '@hotwired/stimulus'
import { animate, toggleVisible } from 'helpers/dom_helpers'
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
  static targets = ['popup', 'container', 'form', 'day']

  async show(event) {
    this._changed = false

    if (this._popupOpen) {
      this._dateString = this.dayElement.dataset.date
      await this._loadContent(this._dateString)
    }

    this._popupOpen = true
    this.dayElement = event.target.closest('.day')
    this._dateString = this.dayElement.dataset.date
    await this._loadContent(this._dateString)
    this._addEventListeners()
  }

  #date() {
    return new Date(this._dateString)
  }

  async changeDay(dayDifference, monthDifference) {
    this._skipAnimation = true
    await this.save()
    setTimeout(async () => {
      const newDate = new Date(this._dateString)
      const dateNumber = this.#date().getDate()
      if (dayDifference) newDate.setDate(dateNumber + dayDifference)
      if (monthDifference) newDate.setMonth(this.#date().getMonth() + monthDifference)
      this._dateString = `${newDate.getFullYear()}-${newDate.getMonth() + 1}-${newDate.getDate()}`
      await this._loadContent(this._dateString)
    }, 200)
  }

  backOneDay() { this.changeDay(-1) }
  backOneMonth() { this.changeDay(undefined, -1) }
  forwardOneDay() { this.changeDay(1) }
  forwardOneMonth() { this.changeDay(undefined, 1) }

  popupTargetConnected() {
    if (this.dayElement) this._movePopup()
  }

  inputChange(_event) {
    this._changed = true
  }

  disconnect() {
    this._removeEventListeners()
  }

  async _loadContent(date) {
    await get(`/entries/day_popup_form/${date}`, { responseKind: 'turbo-stream' })
  }

  _movePopup() {
    if (this._skipAnimation) {
      return this._skipAnimation = false
    }
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
    if (this.formTarget && this._changed) {
      freezeScrollOnNextRender()
      this.formTarget.requestSubmit()
    }
  }
}
