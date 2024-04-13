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
    const index = this.#wrappingIndexForward(this.accordionItemOutlets, (item) => item.focused);

    this.accordionItemOutlets[index].focusTrigger();
  }

  focusPrevious() {
    const index = this.#wrappingIndexBackward(this.accordionItemOutlets, (item) => item.focused);

    this.accordionItemOutlets[index].focusTrigger();
  }

  focusFirst() {
    this.#focusItem(0)
  }

  focusLast() {
    const index = this.accordionItemOutlets.length - 1;

    this.focusItem(index);
  }

  #focusItem(index) {
    this.accordionItemOutlets[index].focusTrigger();
  }

  #wrappingIndexForward() {
    const index = this.accordionItemOutlets.findIndex((item) => item.focused);

    if (index == -1) {
      return 0;
    }

    return (index + 1) % this.accordionItemOutlets.length;
  }

  #wrappingIndexBackward() {
    const index = this.accordionItemOutlets.findIndex((item) => item.focused);
    const length = this.accordionItemOutlets.length;

    if (index == -1) {
      return length - 1;
    }

    return (index - 1 + length) % length;
  }
}
