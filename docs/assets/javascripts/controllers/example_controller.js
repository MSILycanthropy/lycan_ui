import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['preview', 'erb', 'toggle']

  toggle({ target }) {
    if (target.checked) {
      this.showErb()

      return
    }

    this.showPreview()
  }

  showPreview() {
    this.previewTarget.hidden = false
    this.erbTarget.hidden = true
    this.toggleTarget.checked = false
  }

  showErb() {
    this.previewTarget.hidden = true
    this.erbTarget.hidden = false
    this.toggleTarget.checked = true
  }
}
