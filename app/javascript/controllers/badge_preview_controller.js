import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['iconNameField', 'colorField', 'preview']

  connect() {
    super.connect()

    this.iconNameFieldTarget.addEventListener('input', this._updateBadgeIcon.bind(this))
    this.colorFieldTarget.addEventListener('input', this._updateBadgeColor.bind(this))
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
    this.previewTargets.forEach(previewTarget => previewTarget.style = `--badge-color: ${color}`)
  }
}
