import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'panel']

  select({ params: { name } }) {
    this.#selectTab(name)
    this.#showPanel(name)
  }

  selectFirst() {
    const tab = this.#candidateTabs[0]

    if (!tab) return

    tab.focus()
    this.select({ params: { name: tab.getAttribute('data-tabs-name-param') } })
  }

  selectLast() {
    const tab = this.#candidateTabs[this.#candidateTabs.length - 1]

    if (!tab) return

    tab.focus()
    this.select({ params: { name: tab.getAttribute('data-tabs-name-param') } })
  }

  nextTab({ params: { name } }) {
    const selected = this.#tabFor(name)

    if (!selected) return

    const index = this.#candidateTabs.findIndex((tab) => tab === selected)
    const nextTab = this.#candidateTabs[(index + 1) % this.#candidateTabs.length]

    if (!nextTab) return

    nextTab.focus()
    this.select({ params: { name: nextTab.getAttribute('data-tabs-name-param') } })
  }

  prevTab({ params: { name } }) {
    const selected = this.#tabFor(name)

    if (!selected) return

    const index = this.#candidateTabs.findIndex((tab) => tab === selected)
    const nextTab = this.#candidateTabs[(index - 1 + this.#candidateTabs.length) % this.#candidateTabs.length]

    if (!nextTab) return

    nextTab.focus()
    this.select({ params: { name: nextTab.getAttribute('data-tabs-name-param') } })
  }

  #selectTab(name) {
    const tab = this.#tabFor(name)

    if (!tab) return

    this.tabTargets.forEach((tab) => {
      tab.setAttribute("aria-selected", false)
      tab.tabIndex = -1
    })

    tab.tabIndex = 0
    tab.setAttribute("aria-selected", true)
  }

  #showPanel(name) {
    const panel = this.#panelFor(name)

    if (!panel) return

    this.panelTargets.forEach((panel) => panel.hidden = true)

    panel.hidden = false
  }

  #panelFor(name) {
    return this.panelTargets.find((panel) => panel.getAttribute("data-name") === name)
  }

  #tabFor(name) {
    return this.tabTargets.find((panel) => panel.getAttribute("data-tabs-name-param") === name)
  }

  #tabDisabled(tab) {
    return tab.disabled || tab.getAttribute('aria-disabled') === 'true'
  }

  get #candidateTabs() {
    return this.tabTargets.filter((tab) => !this.#tabDisabled(tab))
  }
}
