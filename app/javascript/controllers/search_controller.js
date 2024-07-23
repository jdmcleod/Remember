import { Controller } from "@hotwired/stimulus"
import { useHotkeys } from "stimulus-use/hotkeys";

export default class extends Controller {
  static targets = ['backdrop', 'form', 'input', 'link']

  connect() {
    useHotkeys(this, {
      "command+/": [this.toggle],
      "esc": [this.close],
      "enter": [this.search]
    })
  }

  search() {
    const query = `?q=${this.inputTarget.value}`
    const originalHref = this.linkTarget.href
    this.close()
    this.linkTarget.href += query
    console.log(this.linkTarget)
    this.linkTarget.click()
    this.inputTarget.value = ''
    this.linkTarget.href = originalHref
  }

  isOpen() {
    return !this.formTarget.classList.contains('hidden')
  }

  toggle() {
    this.formTarget.classList.toggle('hidden')
    this.backdropTarget.classList.toggle('hidden')

    if (this.isOpen()) this.inputTarget.focus()
  }

  close() {
    if (this.isOpen()) this.toggle()
  }
}
