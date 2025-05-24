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
    this.close();
  }

  toggle(event) {
    this.focusAfterOpen = this.openValue && event.detail === 0;

    if (this.openValue) {
      this.close();
    } else {
      this.open();
    }
  }

  open() {
    this.openValue = true;
    const updatePosition = this.#updatePosition(
      this.triggerTarget,
      this.contentTarget,
      this.placementValue
    );
    updatePosition();

    this.contentTarget.hidden = false;
    this.contentTarget.dataset.open = true;
    this.triggerTarget.setAttribute("aria-expanded", true);

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
  }

  close() {
    this.openValue = false;
    this.contentTarget.dataset.open = false;
    this.contentTarget.hidden = true;
    this.triggerTarget.setAttribute("aria-expanded", false);

    this.closeAllSubmenus();

    this.#removeClickOutsideListeners();

    if (this.cleanup) this.cleanup();
  }

  focusItem({ target: item }) {
    if (!item) return;
    if (this.#itemDisabled(item)) return;

    if (
      this.hasSubmenuTarget &&
      !this.#isSubmenuCurrentlyOpen(item.dataset.submenu)
    ) {
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
        break;
      case "Escape":
        event.preventDefault();
        this.close();
        break;
      case "ArrowUp":
        event.preventDefault();
        this.#focusPrev(this.itemTargets);
        break;
      case "ArrowDown":
        event.preventDefault();

        if (this.openValue) {
          this.#focusNext(this.itemTargets);
        } else {
          this.focusAfterOpen = true;
          this.open();
        }
        break;
      case "Home":
        event.preventDefault();
        this.focusItem({ target: this.itemTargets[0] });
        break;
      case "End":
        event.preventDefault();
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
        break;
      case "Escape":
        event.preventDefault();
        this.close();
        break;
      case "ArrowUp":
        event.preventDefault();
        this.#focusPrev(itemTargets);
        break;
      case "ArrowDown":
        event.preventDefault();
        this.#focusNext(itemTargets);
        break;
      case "ArrowLeft":
        event.preventDefault();
        this.closeSubmenu(event);
        this.focusSubmenuTrigger(event);
        break;
      case "Home":
        event.preventDefault();
        this.focusItem({ target: itemTargets[0] });
        break;
      case "End":
        event.preventDefault();
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

    if (menu.dataset.open === "true") return;

    menu.dataset.open = true;
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
    const element = this.submenuTargets.find((menu) => menu.id === submenu);

    if (!element) return;

    this.#closeSubmenuByElement(element);
  }

  closeAllSubmenus() {
    this.submenuTargets.forEach((element) =>
      this.#closeSubmenuByElement(element)
    );
  }

  #closeSubmenuByElement(element) {
    element.dataset.open = false;
    element.hidden = true;

    const trigger = this.#submenuTrigger(element.id);
    trigger?.setAttribute("aria-expanded", false);

    if (this.submenuCleanupFns[element.id]) {
      this.submenuCleanupFns[element.id]();
    }
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
    const focused = this.#focusedItemIndex(items);

    if (focused < 0) {
      this.focusItem({ target: candidates.at(-1) });

      return;
    }

    const index = (focused - 1 + length) % length;
    this.focusItem({ target: candidates[index] });
  }

  #isSubmenuCurrentlyOpen(submenu) {
    if (!submenu) return false;

    return this.submenuTargets.some(
      (target) => target.id === submenu && target.dataset.open === "true"
    );
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
      placement,
      middleware: [offset(5), flip(), shift({ padding: 5 })],
    }).then(({ x, y, placement }) => {
      content.dataset.side = placement.split("-")[0];

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
