import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['toggle']

  initialize() {
    this.toggleTargets.forEach((target) => target.checked = this.#useHelper)

    this.#updateBody()
  }

  toggle() {
    if (this.#useHelper) {
      localStorage.setItem('noHelper', 'true')
    } else {
      localStorage.removeItem('noHelper')
    }

    this.#updateBody()
  }

  #updateBody() {
    if (this.#useHelper) {
      document.body.dataset.useHelper = true
    } else {
      document.body.dataset.useHelper = false
    }
  }

  get #useHelper() {
    return localStorage.getItem('noHelper') !== 'true'
  }
}
