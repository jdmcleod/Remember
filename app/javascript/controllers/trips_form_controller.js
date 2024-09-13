import { Controller } from "@hotwired/stimulus"
import { toggleDisplayed } from 'helpers/dom_helpers'

export default class TripsFormController extends Controller {
  static targets = ['checkbox', 'endDateInput', 'endDateInputWrapper', 'decoratorInput']

  toggleFormVersion() {
    toggleDisplayed(this.endDateInputWrapperTarget)
    toggleDisplayed(this.decoratorInputTarget)
  }

  startDateSelected(event) {
    if (this.endDateInputWrapperTarget?.classList?.contains?.('hidden') || this.endDateInputTarget.value) return

    this.endDateInputTarget.value = event.target.value
  }
}
