import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item"];

  focusNext() {
    this.#focusItem(this.#nextIndex)
  }

  focusPrevious() {
    this.#focusItem(this.#previousIndex)
  }

  focusFirst() {
    this.#focusItem(0)
  }

  focusLast() {
    this.#focusItem(this.itemTargets.length - 1);
  }

  #focusItem(index) {
    this.itemTargets[index].focus();
  }

  get #nextIndex() {
    const index = this.itemTargets.findIndex((item) => document.activeElement === item);

    if (index == -1) {
      return 0;
    }

    return (index + 1) % this.itemTargets.length;
  }

  get #previousIndex() {
    const index = this.itemTargets.findIndex((item) => document.activeElement === item);
    const length = this.itemTargets.length;

    if (index == -1) {
      return length - 1;
    }

    return (index - 1 + length) % length;
  }
}
