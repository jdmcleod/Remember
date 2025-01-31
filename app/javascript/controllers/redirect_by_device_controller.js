import { Controller as StimulusController } from "@hotwired/stimulus"
import { isMobile } from 'helpers/screenSizeHelper'

export default class RedirectByDeviceController extends StimulusController {
  static values = {
    url: String,
    firstVisit: Boolean,
  }

  connect() {
    if (isMobile() && !this.firstVisitValue) window.location.href = this.urlValue
  }
}
