import { Controller } from '@hotwired/stimulus'
import { computePosition } from '@floating-ui/dom';
import * as focusTrap from 'focus-trap'

export default class extends Controller {
  static targets = ["trigger", "body"]
  static values = { opened: Boolean }

  connect() {
    this.focusTrap = focusTrap.createFocusTrap(this.bodyTarget, {
      fallbackFocus: this.bodyTarget,
      setReturnFocus: this.triggerTarget,
      allowOutsideClick: this.#allowClickOutside.bind(this),
      onDeactivate: this.#closeBody.bind(this),
      onPostActivate: this.#openBody.bind(this)
    })
  }

  toggle() {
    if (this.openedValue) {
      this.focusTrap.deactivate()
    } else {
      this.focusTrap.activate()
    }
  }

  openedValueChanged() {
    this.triggerTarget.setAttribute('aria-expanded', this.openedValue)
  }

  #openBody() {
    if (this.openedValue) return

    computePosition(this.triggerTarget, this.bodyTarget).then(({ x, y }) => {
      Object.assign(this.bodyTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
    })

    this.bodyTarget.show()
    this.openedValue = true
  }

  #closeBody() {
    if (!this.openedValue) return

    this.bodyTarget.close()

    this.openedValue = false
  }

  #allowClickOutside({ target }) {
    if (target === this.triggerTarget) {
      return true
    }

    if (getComputedStyle(target).position === "absolute") {
      return false
    }

    this.focusTrap.deactivate()
    return true
  }
}
