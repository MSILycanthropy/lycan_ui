import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['preview', 'helper', 'normal', 'toggle']

  toggle({ target }) {
    if (target.checked) {
      this.showErb()

      return
    }

    this.showPreview()
  }

  showPreview() {
    this.previewTarget.hidden = false
    this.helperTarget.hidden = true
    this.normalTarget.hidden = true
    this.toggleTarget.checked = false
  }

  showErb() {
    this.previewTarget.hidden = true
    this.helperTarget.hidden = this.#useHelper
    this.normalTarget.hidden = !this.#useHelper
    this.toggleTarget.checked = true
  }

  get #useHelper() {
    return document.body.dataset.useHelper === 'true'
  }
}
