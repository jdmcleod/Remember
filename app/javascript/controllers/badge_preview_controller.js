import BadgeController from './badge_controller'

export default class extends BadgeController {
  static targets = ['iconNameField', 'colorField', 'preview']

  connect() {
    super.connect()

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
    this._setBadgeColor(color)
  }
}
