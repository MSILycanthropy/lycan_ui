import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body", "trigger"];
  static values = { state: String };
  static classes = ["opened", "closed"];

  open() {
    this.dispatch('opened');

    this.stateValue = 'opened';
  }

  close() {
    this.dispatch('closed');

    this.stateValue = 'closed';

    this.#removeOpenedClasses();
    this.#addClosedClasses();
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

  get focused() {
    return this.triggerTarget === document.activeElement;
  }

  stateValueChanged() {
    this.triggerTarget.setAttribute('aria-expanded', this.#opened);

    if (this.#opened) {
      this.#removeClosedClasses();
      this.#addOpenedClasses();
    } else {
      this.#removeOpenedClasses();
      this.#addClosedClasses();
    }
  }

  ///
  /// private
  ///
  get #opened() {
    return this.stateValue === 'opened';
  }

  #addOpenedClasses() {
    if (!this.hasOpenedClass) return

    this.bodyTarget.classList.add(...this.openedClasses);
  }

  #addClosedClasses() {
    if (!this.hasClosedClass) return

    this.bodyTarget.classList.add(...this.closedClasses);
  }

  #removeOpenedClasses() {
    if (!this.hasOpenedClass) return

    this.bodyTarget.classList.remove(...this.openedClasses);
  }

  #removeClosedClasses() {
    if (!this.hasClosedClass) return

    this.bodyTarget.classList.remove(...this.closedClasses);
  }
}
