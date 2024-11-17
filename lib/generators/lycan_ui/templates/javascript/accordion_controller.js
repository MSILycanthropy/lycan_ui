import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static outlets = ["accordion--item"];
  static values = { multiple: { type: Boolean, default: false } };

  closeOthers() {
    if (this.multipleValue) return;

    this.accordionItemOutlets.forEach((item) => {
      item.close();
    });
  }

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
    this.focusItem(this.accordionItemOutlets.length - 1);
  }

  #focusItem(index) {
    this.accordionItemOutlets[index].focusTrigger();
  }

  get #nextIndex() {
    const index = this.accordionItemOutlets.findIndex((item) => item.focused);

    if (index == -1) {
      return 0;
    }

    return (index + 1) % this.accordionItemOutlets.length;
  }

  get #previousIndex() {
    const index = this.accordionItemOutlets.findIndex((item) => item.focused);
    const length = this.accordionItemOutlets.length;

    if (index == -1) {
      return length - 1;
    }

    return (index - 1 + length) % length;
  }
}