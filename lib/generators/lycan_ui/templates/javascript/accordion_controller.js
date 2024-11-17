import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static outlets = ["ui--accordion--item"];
  static values = { multiple: { type: Boolean, default: false } };

  closeOthers() {
    if (this.multipleValue) return;

    this.uiAccordionItemOutlets.filter((outlet) => outlet.openedValue).forEach((item) => {
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
    this.#focusItem(this.uiAccordionItemOutlets.length - 1);
  }

  #focusItem(index) {
    this.uiAccordionItemOutlets[index].focusTrigger();
  }

  get #nextIndex() {
    const index = this.uiAccordionItemOutlets.findIndex((item) => item.isFocused);

    if (index == -1) {
      return 0;
    }

    return (index + 1) % this.uiAccordionItemOutlets.length;
  }

  get #previousIndex() {
    const index = this.uiAccordionItemOutlets.findIndex((item) => item.isFocused);
    const length = this.uiAccordionItemOutlets.length;

    if (index == -1) {
      return length - 1;
    }

    return (index - 1 + length) % length;
  }
}