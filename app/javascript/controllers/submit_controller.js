import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disable() {
    setTimeout(() => {
      this.element.innerText = 'Downloading...'
      this.element.disabled = true
    }, 100)
  }
}
