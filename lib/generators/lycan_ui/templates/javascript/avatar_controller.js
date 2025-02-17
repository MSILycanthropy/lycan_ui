import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fallback", "image"];

  initialize() {
    if (!this.hasImageTarget) {
      this.showFallback()
      return
    }

    if (!this.imageTarget.complete) {
      this.showFallback()
      return
    }

    if (this.imageTarget.naturalWidth === 0) {
      this.showFallback()
      return
    }

    this.hideFallback()
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
