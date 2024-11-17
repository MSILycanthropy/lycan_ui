import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "trigger"];
  static values = { opened: Boolean };

  connect() {
    this.contentTarget.hidden = false;
    const height = this.contentTarget.scrollHeight;
    this.contentTarget.style.setProperty('--lycan-accordion-content-height', `${height}px`);
    this.contentTarget.hidden = !this.openedValue;
  }

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

  openedValueChanged(value, original) {
    this.triggerTarget.setAttribute('aria-expanded', value);

    this.contentTarget.setAttribute('opened', value)

    if (value) {
      this.contentTarget.hidden = false
      return
    } 

    if (original === undefined) {
      this.contentTarget.hidden = true
      return  
    } 

    this.contentTarget.addEventListener("animationend", () => this.contentTarget.hidden = true, { once: true });
  }

  get isFocused() {
    return this.triggerTarget === document.activeElement;
  }
}