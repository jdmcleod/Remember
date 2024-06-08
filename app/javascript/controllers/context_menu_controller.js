import { Controller } from "@hotwired/stimulus"
import { useTransition } from 'stimulus-use'

/**
 * Stimulus controller for showing/hiding a context menu of actions on an item
 */
export default class ContextMenuController extends Controller {
  static targets = ['menu']
  /**
   * @description Called when the stimulus controller initializes
   * @override Overridden to allow a custom hidden class
   */
  connect() {
    // prevent context menu element from being attached to a controller multiple
    // times during drag/drop scenarios
    useTransition(this, {
      element: this.menuTarget,
      hiddenClass: this.hiddenClass,
      transitioned: false
    })
  }

  toggle() {
    this.toggleTransition()
  }

  get hiddenClass() { return 'context-menu__dropdown--closed' }

  /**
   * @param  {Event} event
   * @description Determine when to call the leave action.
   * @override Overridden to allow a custom hidden class
   */
  hide(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains(this.hiddenClass)) {
      this.leave()
    }
  }

  formSubmission(event) {
    if (event.detail.success) {
      this.toggle()
    }
  }
}
