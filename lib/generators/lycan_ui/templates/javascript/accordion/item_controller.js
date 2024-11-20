import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "trigger"];
  static values = { opened: Boolean };

  open() {
    this.dispatch('opened');

    this.openedValue = true;
  }

  close() {
    this.dispatch('closed');

    this.openedValue = false;
  }

  toggle() {
    if (this.openedValue) {
      this.close();
    } else {
      this.open();
    }
  }

  focusTrigger() {
    this.triggerTarget.focus();
  }

  openedValueChanged(value) {
    this.triggerTarget.setAttribute('aria-expanded', value);
    this.contentTarget.hidden = !value
  }

  get isFocused() {
    return this.triggerTarget === document.activeElement;
  }
}
