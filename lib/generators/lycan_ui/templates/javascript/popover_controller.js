import { Controller } from '@hotwired/stimulus'
import { autoUpdate, computePosition, flip, autoPlacement, offset, arrow } from '@floating-ui/dom';
import * as focusTrap from 'focus-trap'

export default class extends Controller {
  static targets = ["trigger", "body", "arrow"]
  static values = { opened: Boolean, placement: String }

  connect() {
    this.focusTrap = focusTrap.createFocusTrap(this.bodyTarget, {
      fallbackFocus: this.bodyTarget,
      setReturnFocus: this.triggerTarget,
      allowOutsideClick: this.#allowClickOutside.bind(this),
      onDeactivate: () => this.openedValue = false
    })
  }

  toggle() {
    this.openedValue = !this.openedValue
  }

  openedValueChanged(opened) {
    this.triggerTarget.setAttribute('aria-expanded', opened)

    if (!this.focusTrap) return

    if (opened) {
      this.#openBody()
      this.focusTrap.activate()
      return
    }

    this.#closeBody()
    this.focusTrap.deactivate()
  }

  placementValueChanged(_, prevPosition) {
    if (!prevPosition) return

    this.#computePosition()
  }

  #openBody() {
    this.#computePosition()

    this.bodyTarget.show()

    this.bodyTarget.classList.add("block")
  }

  #closeBody() {
    if (this.cleanupAutoUpdate) {
      this.cleanupAutoUpdate()
    }

    this.bodyTarget.close()

    this.bodyTarget.addEventListener("animationend", () => {
      this.bodyTarget.classList.remove("block")
    }, { once: true })
  }

  #computePosition() {
    const positioningMiddleware = []

    if (this.placementValue === "auto") {
      positioningMiddleware.push(autoPlacement())
    } else {
      positioningMiddleware.push(flip())
    }

    if (this.cleanupAutoUpdate) {
      this.cleanupAutoUpdate()
    }

    this.cleanupAutoUpdate = autoUpdate(this.triggerTarget, this.bodyTarget, () => {
      computePosition(this.triggerTarget, this.bodyTarget, {
        placement: this.placementValue,
        middleware: [...positioningMiddleware, offset(10), arrow({ element: this.arrowTarget })]
      }).then(({ x, y, middlewareData, placement }) => {
        Object.assign(this.bodyTarget.style, {
          left: `${x}px`,
          top: `${y}px`,
        })

        if (!middlewareData.arrow) return

        const { x: arrowX, y: arrowY } = middlewareData.arrow;
        let position = {
          left: arrowX !== undefined ? `${arrowX}px` : '',
          top: arrowY !== undefined ? `${arrowY}px` : '',
        };

        const parsedPlacement = placement.split('-')[0]

        switch (parsedPlacement) {
          case "bottom":
            position.top = this.#halfArrowWidth
            break;
          case "top":
            position.bottom = this.#halfArrowWidth
            break;
          case "right":
            position.left = this.#halfArrowWidth
            break;
          case "left":
            position.right = this.#halfArrowWidth
            break;
        }

        Object.assign(this.arrowTarget.style, position);
      })
    })
  }

  #allowClickOutside({ target }) {
    if (target === this.triggerTarget) {
      return true
    }

    if (getComputedStyle(target).position === "absolute") {
      return false
    }

    this.openedValue = false
    return true
  }

  get #halfArrowWidth() {
    return `-${this.arrowTarget.offsetWidth / 2}px`
  }
}
