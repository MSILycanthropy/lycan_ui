import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { confirmed: Boolean }

  connect() {
    this.#form.addEventListener('submit', this.#submit.bind(this), true)
  }

  disconnect() {
    this.#form.removeEventListener('submit', this.#submit.bind(this), true)
  }

  completeSubmission() {
    this.confirmedValue = false
  }

  confirm() {
    this.confirmedValue = true
  }

  deny() {
    this.confirmedValue = false

    this.#close()
  }

  get #form() {
    return this.element.closest('form')
  }

  #submit(event) {
    if (this.confirmedValue) return

    event.preventDefault()

    this.#open()
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
