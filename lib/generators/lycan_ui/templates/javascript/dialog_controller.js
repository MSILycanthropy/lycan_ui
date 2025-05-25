import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    open: Boolean,
    frame: String,
  };
  static targets = ["trigger", "content"];

  connect() {
    if (this.openValue) {
      this.open();
    }
  }

  open() {
    this.contentTarget.showModal();

    this.#bindEventListeners();
  }

  closeOnFormSubmit(event) {
    if (!event.detail.success) return;

    this.close();
  }

  close() {
    this.contentTarget.close();

    this.#removeEventListeners();
  }

  get isRemote() {
    return Boolean(this.frameValue);
  }

  #frameRender = ({ detail }) => {
    if (detail.newFrame.id !== this.frameValue) return;

    detail.render = (_, newFrame) => {
      const selector = `#${this.frameValue} dialog`;

      window.Turbo.renderStreamMessage(
        `
          <turbo-stream action="update" method="morph" targets="${selector}">
            <template>
              ${newFrame.querySelector("dialog").innerHTML}
            </template>
          </turbo-stream>
        `
      );
    };
  };

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

  #bindEventListeners() {
    document.addEventListener("pointerdown", this.#clickOutside);

    if (!this.isRemote) return;

    document.addEventListener("turbo:before-frame-render", this.#frameRender);
  }

  #removeEventListeners() {
    document.removeEventListener("pointerdown", this.#clickOutside);

    if (!this.isRemote) return;

    document.removeEventListener(
      "turbo:before-frame-render",
      this.#frameRender
    );
  }
}
