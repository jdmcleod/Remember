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

    this.dayElement = event.target.closest('.day')
    this._dateString = this.dayElement.dataset.date

    if (this._popupOpen) {
      this._skipAnimation = true
      return this._loadContent(this._dateString)
    }

    this._popupOpen = true
    await this._loadContent(this._dateString)
    this._addEventListeners()
  }

  #date() {
    return new Date(this._dateString)
  }

  /**
   * Its honestly insane how hard it is to do this in Javascript. The timezones get crazy.
   * @param dayDifference
   * @param monthDifference
   * @returns {Promise<void>}
   */
  async changeDay(dayDifference, monthDifference) {
    this._skipAnimation = true
    await this.save()
    setTimeout(async () => {
      const newDate = this.#date()
      const dayNumber = parseInt(this._dateString.split('-')[2])
      const newDayNumber = dayNumber + (dayDifference ?? 0)
      if (dayDifference) newDate.setDate(newDayNumber)
      if (monthDifference) newDate.setMonth(this.#date().getMonth() + monthDifference)
      let nextMonth = newDate.getMonth() + 1
      nextMonth = nextMonth < 10 ? `0${nextMonth}` : nextMonth.toString()
      this._dateString = `${newDate.getFullYear()}-${nextMonth}-${newDayNumber}`
      await this._loadContent(this._dateString)
    }, 200)
  }

  backOneDay() { this.changeDay(-1) }
  backOneMonth() { this.changeDay(undefined, -1) }
  forwardOneDay() { this.changeDay(1) }
  forwardOneMonth() { this.changeDay(undefined, 1) }

  popupTargetConnected() {
    if (this.dayElement && !this._skipAnimation) {
      this._skipAnimation = false
      animate(this.popupTarget, 'zoomIn')
    }
  }

  inputChange(_event) {
    this._changed = true
  }

  disconnect() {
    this._removeEventListeners()
  }

  async _loadContent(date) {
    await get(`/days/popup_form/${date}`, { responseKind: 'turbo-stream' })
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
      this._skipAnimation = false
    }, 150)
  }

  save() {
    if (this.formTarget && this._changed) {
      freezeScrollOnNextRender()
      this.formTarget.requestSubmit()
    }
  }

  #dateToUtc(date) {
    return new Date(Date.UTC(
      date.getFullYear(),
      date.getMonth(),
      date.getDate(),
      date.getHours(),
      date.getMinutes(),
      date.getSeconds()
    ));
  }
}
