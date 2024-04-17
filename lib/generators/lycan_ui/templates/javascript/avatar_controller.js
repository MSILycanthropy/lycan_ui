import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { src: String }
  static targets = ["avatar", "fallback"];

  connect() {
    if (!this.hasFallbackTarget) return

    this.avatarTarget.onload = () => {
      this.hideFallback();
    }

    this.avatarTarget.onerror = () => {
      this.showFallback();
    }
  }

  srcValueChanged() {
    this.avatarTarget.src = this.srcValue;
  }

  hideFallback() {
    this.fallbackTarget.hidden = true;

    this.avatarTarget.hidden = false;
  }

  showFallback() {
    this.fallbackTarget.hidden = false;

    this.avatarTarget.hidden = true;
  }
}
