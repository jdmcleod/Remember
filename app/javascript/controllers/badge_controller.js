import { Controller } from "@hotwired/stimulus"
import linearShadeColor from '../helpers/linearShadeColor'

export default class BadgeController extends Controller {
  static values = { color: String }

  connect() {
    super.connect()

    this._setBadgeColor(this.element, this.colorValue)
  }

  _setBadgeColor(element, color) {
    const badge = element.querySelector('.badge') ?? element
    badge.style = `--badge-color: ${color}; --badge-fill-color: ${linearShadeColor(color, 0.85)}`
  }
}
