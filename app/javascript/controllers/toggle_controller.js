import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ['element']
  static classes = ['active']

  static values = {
    performOnConnect: {
      type: Boolean,
      default: false,
    },
    closeOnClickOutside: Boolean
  }

  connect() {
    if (this.performOnConnectValue) this.perform()

    if (this.closeOnClickOutsideValue) {
      useClickOutside(this, { element: this.element })
    }
  }

  perform() {
    if (this.hasElementTarget) {
      this.elementTargets.forEach(this._toggleActiveClass.bind(this))
    } else {
      this._toggleActiveClass(this.element)
    }
  }

  on() {
    if (this.hasElementTarget) {
      this.elementTargets.forEach(element => this._toggleActiveClass(element, true))
    } else {
      this._toggleActiveClass(this.element, true)
    }
  }

  off() {
    if (this.hasElementTarget) {
      this.elementTargets.forEach(element => this._toggleActiveClass(element, false))
    } else {
      this._toggleActiveClass(this.element, false)
    }
  }

  _toggleActiveClass(element, direction = !element.classList.contains(this.activeClass)) {
    // next-tick to allow animation-in after connect
    setTimeout(()=>{element.classList.toggle(this.activeClass, direction)}, 0)
  }
}
