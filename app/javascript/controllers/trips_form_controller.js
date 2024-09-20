import { Controller } from "@hotwired/stimulus"
import { toggleDisplayed } from 'helpers/dom_helpers'

export default class TripsFormController extends Controller {
  static targets = ['checkbox', 'endDateInput', 'hideForDecoration', 'decoratorInput']

  toggleFormVersion() {
    this.hideForDecorationTargets.forEach(t => toggleDisplayed(t))
    toggleDisplayed(this.decoratorInputTarget)
  }

  startDateSelected(event) {
    if (this.hideForDecorationTargets[0]?.classList?.contains?.('hidden') || this.endDateInputTarget.value) return

    this.endDateInputTarget.value = event.target.value
  }
}
