import { Controller as StimulusController } from "@hotwired/stimulus"
import { isMobile } from 'helpers/screenSizeHelper'

export default class RedirectByDeviceController extends StimulusController {
  static values = {
    url: String,
    shouldRedirect: Boolean,
  }

  connect() {
    if (isMobile() && this.shouldRedirectValue) window.location.href = this.urlValue
  }
}
