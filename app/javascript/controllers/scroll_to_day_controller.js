import { Controller as StimulusController } from "@hotwired/stimulus"

export default class extends StimulusController {
  static values = {
    date: String,
  }

  connect() {
    if (this.dateValue) {
      const node = document.querySelector(`[data-date="${this.dateValue}"]`)
      node.scrollIntoView({ behavior: 'smooth', block: 'center' })
      node.click()
    }
  }
}
