import { Controller } from "@hotwired/stimulus";
import {
  autoUpdate,
  computePosition,
  offset,
  flip,
  shift,
} from "@floating-ui/dom";

export default class extends Controller {
  static values = {
    open: Boolean,
    placement: { type: String, default: "bottom" },
    query: String,
    queryReset: { type: Number, default: 500 },
    typeahead: { type: Boolean, default: true },
  };
  static targets = ["trigger", "content", "item", "submenu", "submenuItem"];

  focusAfterOpen = false;
  searchTimeout = null;
  submenuCleanupFns = {};

  connect() {
    this.#updatePosition();
  }

  toggle(event) {
    this.openValue = !this.openValue;
    this.focusAfterOpen = this.openValue && event.detail === 0;
  }

  open() {
    this.openValue = true;
  }

  close() {
    this.closeAllSubmenus();

    this.openValue = false;
  }

  focusItem({ target: item }) {
    if (!item) return;
    if (this.#itemDisabled(item)) return;

    if (!item.dataset.submenu) {
      this.closeAllSubmenus();
    }

    this.itemTargets.forEach((i) => (i.tabIndex = -1));

    item.tabIndex = 0;
    item.focus();
  }

  focusTrigger() {
    this.itemTargets.forEach((i) => (i.tabIndex = -1));

    this.triggerTarget.focus();
  }

  focusSubmenuTrigger({ params: { submenu } }) {
    this.#submenuItems(submenu).forEach((i) => (i.tabIndex = -1));

    const trigger = this.#submenuTrigger(submenu);

    trigger?.focus();
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Tab":
        event.preventDefault();
        break;
      case "Escape":
        this.close();
        break;
      case "ArrowUp":
        this.#focusPrev(this.itemTargets);
        break;
      case "ArrowDown":
        this.#focusNext(this.itemTargets);
        break;
      case "Home":
        this.focusItem({ target: this.itemTargets[0] });
        break;
      case "End":
        this.focusItem({
          target: this.itemTargets[this.itemTargets.length - 1],
        });
        break;
      default:
        this.#typeahead(event);
    }
  }

  submenuHandleKeydown(event) {
    event.stopPropagation();

    const submenuId = event.params.submenu;
    const itemTargets = this.#submenuItems(submenuId);

    switch (event.key) {
      case "Tab":
        event.preventDefault();
        break;
      case "Escape":
        this.close();
        break;
      case "ArrowUp":
        this.#focusPrev(itemTargets);
        break;
      case "ArrowDown":
        this.#focusNext(itemTargets);
        break;
      case "ArrowLeft":
        this.closeSubmenu(event);
        this.focusSubmenuTrigger(event);
        break;
      case "Home":
        this.focusItem({ target: itemTargets[0] });
        break;
      case "End":
        this.focusItem({
          target: itemTargets[itemTargets.length - 1],
        });
        break;
    }
  }

  openSubmenu(event) {
    const {
      currentTarget,
      params: { submenu, placement },
    } = event;

    const menu = this.submenuTargets.find((element) => element.id === submenu);

    if (!menu) return;

    menu.hidden = false;
    const updatePosition = this.#updatePosition(currentTarget, menu, placement);

    updatePosition();
    this.submenuCleanupFns[submenu] = autoUpdate(
      this.triggerTarget,
      this.contentTarget,
      updatePosition
    );

    currentTarget.setAttribute("aria-expanded", true);

    const itemTargets = this.submenuItemTargets.filter(
      (item) => item.dataset.submenu === submenu
    );

    itemTargets.forEach((item) => (item.tabIndex = -1));

    if (event.key && event.detail === 0) {
      this.focusItem({ target: itemTargets[0] });
    }
  }

  closeSubmenu({ params: { submenu } }) {
    const menu = this.submenuTargets.find((element) => element.id === submenu);

    if (!menu) return;

    menu.hidden = true;

    const trigger = this.#submenuTrigger(submenu);

    trigger?.setAttribute("aria-expanded", false);

    if (this.submenuCleanupFns[submenu]) {
      this.submenuCleanupFns[submenu]();
    }
  }

  closeAllSubmenus() {
    this.submenuTargets.forEach((element) => {
      element.hidden = true;

      const trigger = this.#submenuTrigger(element.id);

      trigger?.setAttribute("aria-expanded", false);

      if (this.submenuCleanupFns[element.id]) {
        this.submenuCleanupFns[element.id]();
      }
    });
  }

  openValueChanged(open) {
    this.contentTarget.hidden = !open;

    this.triggerTarget.setAttribute("aria-expanded", open);

    if (open) {
      const updatePosition = this.#updatePosition(
        this.triggerTarget,
        this.contentTarget,
        this.placementValue
      );
      updatePosition();
      this.#bindClickOutsideListeners();

      this.cleanup = autoUpdate(
        this.triggerTarget,
        this.contentTarget,
        updatePosition
      );

      this.itemTargets.forEach((i) => (i.tabIndex = -1));

      if (this.focusAfterOpen) {
        this.focusItem({ target: this.itemTargets[0] });
        this.focusAfterOpen = false;
      }

      return;
    }

    this.#removeClickOutsideListeners();

    if (this.cleanup) this.cleanup();
  }

  #itemDisabled(item) {
    return item.disabled || item.getAttribute("aria-disabled") === "true";
  }

  #typeahead(event) {
    if (!this.typeaheadValue) return;
    if (!this.openValue) return;
    if (event.ctrlKey || event.altKey || event.metaKey) return;
    if (event.key.length !== 1) return;

    event.preventDefault();

    if (this.searchTimeout) clearTimeout(this.searchTimeout);

    this.queryValue += event.key.toLowerCase();

    const isRepeated =
      this.queryValue.length > 1 &&
      this.queryValue.split("").every((char) => char === this.queryValue[0]);
    const normalizedQuery = isRepeated ? this.queryValue[0] : this.queryValue;

    const focusedIndex = this.#focusedItemIndex(this.itemTargets);
    const candidates = this.#candidateItems(this.itemTargets);
    const currentIndex = Math.max(focusedIndex, 0);
    const currentItem = focusedIndex === -1 ? null : candidates[currentIndex];
    let items = candidates.map(
      (_, index, array) => array[(currentIndex + index) % array.length]
    );

    if (normalizedQuery.length === 1) {
      items = items.filter((item) => item !== currentItem);
    }

    let nextItem = items.find(
      (item) =>
        item?.innerText &&
        item.innerText.trim().toLowerCase().startsWith(normalizedQuery)
    );

    if (nextItem !== currentItem) this.focusItem({ target: nextItem });

    this.searchTimeout = setTimeout(() => {
      this.queryValue = "";
      this.searchTimeout = null;
    }, this.queryResetValue);
  }

  #focusNext(items) {
    const candidates = this.#candidateItems(items);
    const index = (this.#focusedItemIndex(items) + 1) % candidates.length;

    this.focusItem({ target: candidates[index] });
  }

  #focusPrev(items) {
    const candidates = this.#candidateItems(items);
    const length = candidates.length;
    const index = (this.#focusedItemIndex(items) - 1 + length) % length;
    this.focusItem({ target: candidates[index] });
  }

  #submenuTrigger(id) {
    return this.itemTargets.find(
      (trigger) => trigger.getAttribute("aria-controls") === id
    );
  }

  #submenuItems(id) {
    return this.submenuItemTargets.filter(
      (item) => item.dataset.submenu === id
    );
  }

  #focusedItemIndex(items) {
    return this.#candidateItems(items).findIndex(
      (item) => document.activeElement === item
    );
  }

  #candidateItems(items) {
    return items.filter((item) => !this.#itemDisabled(item));
  }

  #updatePosition = (trigger, content, placement) => () => {
    computePosition(trigger, content, {
      placement: placement,
      middleware: [offset(5), flip(), shift({ padding: 5 })],
    }).then(({ x, y }) => {
      Object.assign(content.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
    });
  };

  #clickOutside = ({ target }) => {
    if (this.element.contains(target)) return;

    this.close();
  };

  #bindClickOutsideListeners() {
    document.addEventListener("click", this.#clickOutside);
    document.addEventListener("touchend", this.#clickOutside);
    document.addEventListener("focusin", this.#clickOutside);
  }

  #removeClickOutsideListeners() {
    document.removeEventListener("click", this.#clickOutside);
    document.removeEventListener("touchend", this.#clickOutside);
    document.removeEventListener("focusin", this.#clickOutside);
  }
}
