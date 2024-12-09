import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['preview', 'erb', 'javascript']

  showPreview() {
    this.previewTarget.hidden = false
    this.erbTarget.hidden = true
    this.javascriptTarget.hidden = true
  }

  showErb() {
    this.previewTarget.hidden = true
    this.erbTarget.hidden = false
    this.javascriptTarget.hidden = true
  }

  showJavascript() {
    this.previewTarget.hidden = true
    this.erbTarget.hidden = true
    this.javascriptTarget.hidden = false
  }
}
