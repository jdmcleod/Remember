import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input']

  async execute() {
    setTimeout(() => this.inputTarget.value = '', 100)
  }
}
