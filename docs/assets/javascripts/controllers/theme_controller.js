import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['light', 'dark']

  initialize() {
    console.log(this.darkTarget)

    this.#showCorrectElement()
  }

  toggle() {
    if (this.#isDark) {
      document.documentElement.classList.remove('dark')
    } else {
      document.documentElement.classList.add('dark')
    }

    this.#showCorrectElement()
  }

  #showCorrectElement() {
    this.darkTarget.hidden = true

    this.lightTarget.hidden = this.#isDark
    this.darkTarget.hidden = !this.#isDark
  }

  get #isDark() {
    return document.documentElement.classList.contains('dark')
  }
}
