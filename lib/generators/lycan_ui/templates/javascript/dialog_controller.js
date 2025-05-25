import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "content"];

  open() {
    this.contentTarget.showModal();

    this.#bindClickOutsideListeners();
  }

  closeOnFormSubmit(event) {
    if (!event.detail.success) return;

    this.close();
  }

  close() {
    this.contentTarget.close();

    this.#removeClickOutsideListeners();
  }

  #clickOutside = ({ clientX, clientY }) => {
    const { top, left, height, width } =
      this.contentTarget.getBoundingClientRect();
    if (
      top <= clientY &&
      clientY <= top + height &&
      left <= clientX &&
      clientX <= left + width
    ) {
      return;
    }

    this.close();
  };

  #bindClickOutsideListeners() {
    document.addEventListener("pointerdown", this.#clickOutside);
  }

  #removeClickOutsideListeners() {
    document.removeEventListener("pointerdown", this.#clickOutside);
  }
}
