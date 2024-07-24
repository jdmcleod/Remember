import { Controller } from '@hotwired/stimulus'

export default class LiveFilterController extends Controller {
  static values = {
    hiddenClass: { type: String, default: 'hidden' }
  }
  static targets = ['source', 'filterable']

  filter() {
    let lowerCaseFilterTerm = this.sourceTarget.value.toLowerCase()

    this.filterableTargets.forEach((element, i) => {
      let filterableKey =  element.getAttribute("data-filter-key")

      element.classList.toggle(this.hiddenClassValue, !filterableKey.includes(lowerCaseFilterTerm) )
    })
  }
}
