import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fallback", "image"];

  connect() {
    if (this.hasImageTarget && this.imageTarget.complete) {
      this.hideFallback();
    } else {
      this.showFallback();
    }
  }

  showFallback() {
    this.fallbackTarget.hidden = false;
    this.imageTarget.hidden = true;
  }

  hideFallback() {
    this.imageTarget.hidden = false;
    this.fallbackTarget.hidden = true;
  }
}
