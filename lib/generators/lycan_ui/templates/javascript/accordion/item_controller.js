import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "trigger"];
  static values = { state: String };

  open() {
    this.dispatch('opened');

    this.stateValue = 'opened';
  }

  close() {
    this.dispatch('closed');

    this.stateValue = 'closed';
  }

  toggle() {
    if (this.#opened) {
      this.close();
    } else {  
      this.open();
    }
  }

  focusTrigger() {
    this.triggerTarget.focus();
  }

  stateValueChanged() {
    this.triggerTarget.setAttribute('aria-expanded', this.#opened);

    this.contentTarget.hidden = !this.#opened;
  }

  get isFocused() {
    return this.triggerTarget === document.activeElement;
  }

  get #opened() {
    return this.stateValue === 'opened';
  }
}