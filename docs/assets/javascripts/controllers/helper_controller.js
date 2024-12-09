import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggle() {
    if (document.body.dataset.useHelper === 'true') {
      document.body.dataset.useHelper = false
    } else {
      document.body.dataset.useHelper = true
    }

    document.dispatchEvent(new CustomEvent('helper-change'))
  }
}
