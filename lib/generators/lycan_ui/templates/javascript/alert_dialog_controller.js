import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  submitted = false

  async pauseSubmission({ detail: { formSubmission } }) {
    if (this.submitted) return
    if (formSubmission.formElement !== this.#form) return

    formSubmission.stop()

    this.#open()

    this.element.addEventListener(
      'alert-dialog:confirmation',
      ({ detail: { confirmed } }) => {
        this.submitted = confirmed

        if (!confirmed) return

        this.#form.requestSubmit()
      },
      { once: true }
    )
  }

  completeSubmission() {
    this.submitted = false
  }

  confirm() {
    this.dispatch("confirmation", { detail: { confirmed: true } })

    this.#close()
  }

  deny() {
    this.dispatch("confirmation", { detail: { confirmed: false } })

    this.#close()
  }

  get #form() {
    return this.element.closest('form')
  }

  #open() {
    this.element.showModal()


  }

  #close() {
    this.element.setAttribute('data-closing', '')

    this.element.addEventListener('animationend', () => {
      this.element.close()
      this.element.removeAttribute('data-closing')
    }, { once: true })
  }
}
