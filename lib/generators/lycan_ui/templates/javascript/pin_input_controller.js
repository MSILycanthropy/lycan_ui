import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { array: Array }
  static targets = ["field", "hiddenField"]

  fillAll(event) {
    event.preventDefault();

    const clipboardData = event.clipboardData
    if (!clipboardData) return

    const contents = clipboardData.getData('text')

    const startIndex = contents.length >= this.fieldTargets.length ? 0 : this.#currentIndex
    const endIndex = Math.min(startIndex + contents.length, this.fieldTargets.length)

    for (let i = startIndex; i < endIndex; i++) {
      const field = this.fieldTargets[i]
      const currentChar = contents[i - startIndex]

      if (this.#isAlphanumeric(currentChar)) {
        field.value = currentChar
      } else {
        field.value = null
      }

      field.focus()
    }

    this.fieldTargets[endIndex]?.focus()

    this.#updateArray()
  }

  nextField(event) {
    if (this.#currentIndex >= this.fieldTargets.length - 1) return

    event.preventDefault()

    this.#focusNextField()
  }

  prevField(event) {
    if (this.#currentIndex <= 0) return

    event.preventDefault()

    this.#focusPrevField()
  }

  delete({ key, target }) {
    if (key !== "Delete") return

    target.value = null
  }

  prevFieldBackspace({ key, target }) {
    if (key !== "Backspace") return
    if (target.value) return

    this.#focusPrevField()
  }

  set({ data, target }) {
    if (this.#isAlphanumeric(data)) {
      target.value = data
    } else {
      target.value = null
    }

    if (data) {
      this.#focusNextField()
    }

    this.#updateArray()
  }

  arrayValueChanged(value) {
    this.hiddenFieldTarget.value = value.join('')
  }

  get #currentIndex() {
    return this.fieldTargets.findIndex((field) => document.activeElement === field)
  }

  #isAlphanumeric(char) {
    return /[a-zA-Z0-9]/.test(char)
  }

  #updateArray() {
    this.arrayValue = this.fieldTargets.map((field) => field.value.slice(-1) || undefined)
  }

  #focusNextField() {
    const nextIndex = this.#currentIndex + 1

    if (nextIndex >= this.fieldTargets.length) return

    this.fieldTargets[nextIndex].focus()
  }

  #focusPrevField() {
    const prevIndex = this.#currentIndex - 1

    if (prevIndex < 0) return

    this.fieldTargets[prevIndex].focus()
  }
}
