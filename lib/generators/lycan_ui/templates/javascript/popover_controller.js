import { Controller } from "@hotwired/stimulus";
import {
  autoUpdate,
  computePosition,
  offset,
  arrow,
  flip,
  shift,
} from "@floating-ui/dom";
import * as focusTrap from "focus-trap";

export default class extends Controller {
  static targets = ["trigger", "content", "arrow"];
  static values = {
    open: Boolean,
    placement: { type: String, default: "bottom" },
    offset: { type: Number, default: 8 },
  };

  connect() {
    this.#updatePosition();

    this.focusTrap = focusTrap.createFocusTrap(this.contentTarget, {
      fallbackFocus: this.contentTarget,
      setReturnFocus: this.triggerTarget,
      allowOutsideClick: true,
      escapeDeactivates: false,
      clickOutsideDeactivates: false,
    });
  }

  disconnect() {
    this.close();
  }

  toggle() {
    if (this.openValue) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.openValue = true;
    this.contentTarget.show();

    this.#updatePosition();

    this.cleanup = autoUpdate(
      this.triggerTarget,
      this.contentTarget,
      this.#updatePosition
    );
    this.#bindClickOutsideListeners();

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.focusTrap.activate();
      });
    });
  }

  close() {
    this.openValue = false;
    this.contentTarget.close();
    this.focusTrap.deactivate();

    this.#removeClickOutsideListeners();
    if (this.cleanup) this.cleanup();
  }

  #updatePosition = () => {
    computePosition(this.triggerTarget, this.contentTarget, {
      placement: this.placementValue,
      middleware: [offset(5), flip(), shift({ padding: 5 })],
    }).then(({ x, y, placement }) => {
      this.contentTarget.dataset.side = placement.split("-")[0];

      Object.assign(this.contentTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
    });
  };

  #clickOutside = ({ target }) => {
    if (this.element.contains(target)) return;

    this.close();
  };

  #escPressed = (event) => {
    if (event.key !== "Escape") return;

    event.preventDefault();

    this.close();
  };

  #bindClickOutsideListeners() {
    document.addEventListener("click", this.#clickOutside);
    document.addEventListener("touchend", this.#clickOutside);
    document.addEventListener("focusin", this.#clickOutside);
    document.addEventListener("keydown", this.#escPressed);
  }

  #removeClickOutsideListeners() {
    document.removeEventListener("click", this.#clickOutside);
    document.removeEventListener("touchend", this.#clickOutside);
    document.removeEventListener("focusin", this.#clickOutside);
    document.removeEventListener("keydown", this.#escPressed);
  }
}
