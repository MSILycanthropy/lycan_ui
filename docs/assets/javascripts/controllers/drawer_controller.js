import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets=["dialog"]

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    if (!this.dialogTarget.checkVisibility || !this.dialogTarget.checkVisibility()) {
      return
    }

    this.dialogTarget.close()

    this.showTrigger()
  }

  nothing() {}
}
