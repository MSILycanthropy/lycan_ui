import { Controller } from '@hotwired/stimulus'
import { autoUpdate, computePosition, offset, flip, shift } from '@floating-ui/dom'

export default class extends Controller {
  static values = {
    open: Boolean,
    placement: { type: String, default: 'bottom' },
    query: String,
    queryReset: { type: Number, default: 500 },
    typeahead: { type: Boolean, default: true }
  }
  static targets = ['trigger', 'content', 'item']

  focusAfterOpen = false
  searchTimeout = null

  connect() {
    this.#updatePosition()
  }

  toggle(event) {
    this.openValue = !this.openValue
    this.focusAfterOpen = this.openValue && event.detail === 0
  }

  open() {
    this.openValue = true
  }

  close() {
    this.openValue = false
  }

  focusItem({ target: item }) {
    if (!item) return
    if (this.#itemDisabled(item)) return

    this.itemTargets.forEach((i) => i.tabIndex = -1)

    item.tabIndex = 0
    item.focus()
  }

  focusTrigger() {
    this.itemTargets.forEach((i) => i.tabIndex = -1)

    this.triggerTarget.focus()
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Tab":
        break;
      case "Escape":
        this.close()
        break;
      case "ArrowUp":
        this.#focusPrev()
        break;
      case "ArrowDown":
        if (this.openValue) {
          this.#focusNext()
        } else {
          this.open()
          this.focusAfterOpen = true
        }
        break;
      case "Home":
        this.focusItem({ target: this.itemTargets[0] })
        break;
      case "End":
        this.focusItem({ target: this.itemTargets[this.itemTargets.length - 1 ] })
        break;
      default:
        this.#typeahead(event)
    }
  }

  openValueChanged(open) {
    this.contentTarget.hidden = !open

    this.triggerTarget.setAttribute('aria-expanded', open)

    if (open) {
      this.#updatePosition()
      this.#bindClickOutsideListeners()

      this.cleanup = autoUpdate(
        this.triggerTarget,
        this.contentTarget,
        this.#updatePosition
      )

      if (this.focusAfterOpen) {
        this.focusItem({ target: this.itemTargets[0] })
        this.focusAfterOpen = false
      }

      return
    }

    this.#removeClickOutsideListeners()

    if (this.cleanup) this.cleanup()
  }

  #itemDisabled(item) {
    return item.disabled || item.getAttribute('aria-disabled') === 'true'
  }

  #typeahead(event) {
    if (!this.typeaheadValue) return
    if (!this.openValue) return
    if (event.ctrlKey || event.altKey || event.metaKey) return
    if (event.key.length !== 1) return

    event.preventDefault()

    if (this.searchTimeout) clearTimeout(this.searchTimeout)

    this.queryValue += event.key.toLowerCase()

    const isRepeated = this.queryValue.length > 1 && this.queryValue.split('').every((char) => char === this.queryValue[0]);
    const normalizedQuery = isRepeated ? this.queryValue[0] : this.queryValue

    const currentIndex = Math.max(this.#focusedItemIndex, 0)
    const currentItem = this.#focusedItemIndex === -1 ? null : this.#candidateItems[currentIndex]
    let items = this.#candidateItems
      .map((_, index, array) => array[(currentIndex + index) % array.length])

		if (normalizedQuery.length === 1) {
			items = items.filter((item) => item !== currentItem);
		}

    let nextItem = items.find((item) => item?.innerText && item.innerText.trim().toLowerCase().startsWith(normalizedQuery))

    if (nextItem !== currentItem) this.focusItem({ target: nextItem })

    this.searchTimeout = setTimeout(() => {
      this.queryValue = ''
      this.searchTimeout = null
    }, this.queryResetValue)
  }

  #focusNext() {
    if (!this.openValue) return
    if (!this.hasItemTarget) return

    const index = (this.#focusedItemIndex + 1) % this.#candidateItems.length
    this.focusItem({ target: this.#candidateItems[index] })
  }

  #focusPrev() {
    if (!this.openValue) return
    if (!this.hasItemTarget) return

    const length = this.#candidateItems.length
    const index = (this.#focusedItemIndex - 1 + length) % length
    this.focusItem({ target: this.#candidateItems[index] })
  }

  get #focusedItemIndex() {
    return this.#candidateItems.findIndex((item) => document.activeElement === item);
  }

  get #candidateItems() {
    return this.itemTargets.filter((item) => !this.#itemDisabled(item))
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
    document.addEventListener('focusin', this.#clickOutside)
  }

  #removeClickOutsideListeners() {
    document.removeEventListener('click', this.#clickOutside)
    document.removeEventListener('touchend', this.#clickOutside)
    document.removeEventListener('focusin', this.#clickOutside)
  }
}
