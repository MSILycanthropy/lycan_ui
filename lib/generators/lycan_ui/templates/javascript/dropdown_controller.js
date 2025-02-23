import { Controller } from '@hotwired/stimulus'
import { autoUpdate, computePosition, offset, flip, shift } from '@floating-ui/dom'

// TODO: Ensure accessibility
export default class extends Controller {
  static values = { open: Boolean, placement: { type: String, default: 'bottom' } }
  static targets = ['trigger', 'content']

  connect() {
    this.#updatePosition()
  }

  toggle() {
    this.openValue = !this.openValue
  }

  open() {
    this.openValue = true
  }

  close() {
    this.openValue = false
  }

  openValueChanged(value) {
    this.contentTarget.hidden = !value

    this.triggerTarget.setAttribute('aria-expanded', value)

    if (value) {
      this.#updatePosition()
      this.#bindClickOutsideListeners()

      this.cleanup = autoUpdate(
        this.triggerTarget,
        this.contentTarget,
        this.#updatePosition
      )
      return
    }

    this.#removeClickOutsideListeners()

    if (this.cleanup) this.cleanup()
  }

  #updatePosition = () => {
    computePosition(this.triggerTarget, this.contentTarget, {
      placement: this.placementValue,
      middleware: [offset(5), flip(), shift({ padding: 5 })],
    }).then(({ x, y }) => {
      Object.assign(this.contentTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      })
    })
  }

  #clickOutside = ({ target }) => {
    if (this.element.contains(target)) return

    this.close()
  }

  #bindClickOutsideListeners() {
    document.addEventListener('click', this.#clickOutside)
    document.addEventListener('touchend', this.#clickOutside)
  }

  #removeClickOutsideListeners() {
    document.removeEventListener('click', this.#clickOutside)
    document.removeEventListener('touchend', this.#clickOutside)
  }
}
