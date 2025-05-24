import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["trigger", "content"];
  static values = { open: Boolean };

  toggle() {
    this.openValue = !this.openValue;
  }

  open() {
    this.openValue = true;
  }

  close() {
    this.openValue = false;
  }

  openValueChanged(open) {
    this.triggerTarget.ariaExpanded = open;
    this.contentTarget.hidden = !open;
  }
}
