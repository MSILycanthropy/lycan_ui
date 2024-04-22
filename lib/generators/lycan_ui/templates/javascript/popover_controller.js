import { Controller } from '@hotwired/stimulus'
import { computePosition, flip, offset, arrow } from '@floating-ui/dom';
import * as focusTrap from 'focus-trap'

export default class extends Controller {
  static targets = ["trigger", "body", "arrow"]
  static values = { opened: Boolean }

  connect() {
    this.focusTrap = focusTrap.createFocusTrap(this.bodyTarget, {
      fallbackFocus: this.bodyTarget,
      setReturnFocus: this.triggerTarget,
      allowOutsideClick: this.#allowClickOutside.bind(this),
      onDeactivate: () => this.openedValue = false,
      onActivate: () => this.openedValue = true
    })
  }

  toggle() {
    this.openedValue = !this.openedValue
  }

  openedValueChanged() {
    this.triggerTarget.setAttribute('aria-expanded', this.openedValue)

    if (!this.focusTrap) return

    if (this.openedValue) {
      this.#openBody()
      this.focusTrap.activate()
    } else {
      this.#closeBody()
      this.focusTrap.deactivate()
    }
  }

  #openBody() {
    computePosition(this.triggerTarget, this.bodyTarget, {
      middleware: [flip(), offset(10), arrow({ element: this.arrowTarget })]
    }).then(({ x, y, middlewareData }) => {
      Object.assign(this.bodyTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      })

      if (middlewareData.arrow) {
        const { x, y } = middlewareData.arrow;

        Object.assign(this.arrowTarget.style, {
          left: x != null ? `${x}px` : '',
          top: y != null ? `${y}px` : '',
        });
      }
    })

    this.bodyTarget.show()
  }

  #closeBody() {
    this.bodyTarget.setAttribute('data-closing', '')

    this.bodyTarget.addEventListener('animationend', () => {
      this.bodyTarget.close()
      this.bodyTarget.removeAttribute('data-closing')
    }, { once: true })
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
