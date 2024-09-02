import linearShadeColor from 'helpers/linearShadeColor'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['iconNameField', 'colorField', 'preview']
  static values = { color: String }

  connect() {
    super.connect()

    this._setBadgeColor(this.element, this.colorValue)
    this.iconNameFieldTarget.addEventListener('input', this._updateBadgeIcon.bind(this))
    this.colorFieldTarget.addEventListener('input', this._updateBadgeColor.bind(this))
    this.previewTargets.forEach(previewTarget => this._setBadgeColor(previewTarget, this.colorFieldTarget.value))
    this.setCurrentIconName(this.iconNameFieldTarget.value)
  }

  currentIconName() { return this._currentIconName }
  setCurrentIconName(newIconName) { this._currentIconName = newIconName }

  _updateBadgeIcon(event) {
    const iconName = event.target.value
    this.previewTargets.forEach(previewTarget => previewTarget.querySelector('.icon').classList.replace(`ti-${this.currentIconName()}`, `ti-${iconName}`))
    this.setCurrentIconName(iconName)
  }

  _updateBadgeColor(event) {
    const color = event.target.value
    this.previewTargets.forEach(previewTarget => this._setBadgeColor(previewTarget, color))
  }

  _setBadgeColor(element, color) {
    const badge = element.querySelector('.badge') ?? element
    badge.style = `--badge-color: ${color}; --badge-fill-color: ${linearShadeColor(color, 0.85)}`
  }
}
