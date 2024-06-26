import { LitElement, css, html } from "lit"

export default class REMBeRealPerson extends LitElement {
  static properties = {
    name: { type: String },
    src: { type: String }
  }

  constructor() {
    super()
    this.name = ''
    this.src = ''
  }

  render() {
    return html`
      <span>${this.name}</span>
      <rem-avatar src='${this.src}' alt='${this.name}' size='medium'></rem-avatar>
    `
  }

  static styles = css`
    :host {
      display: inline-flex;
      align-items: center;
      gap: var(--op-space-small);

      box-shadow: var(--op-border-all) var(--op-color-border);
      border-radius: var(--op-radius-pill);
      padding: var(--op-space-small);
    }
  `
}
