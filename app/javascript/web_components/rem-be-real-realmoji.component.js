import { LitElement, css, html } from "lit"

export default class REMBeRealRealmoji extends LitElement {
  static properties = {
    emoji: { type: String },
    src: { type: String }
  }

  constructor() {
    super()
    this.emoji = ''
    this.src = ''
  }

  render() {
    return html`
      <span>${this.emoji}</span>
      <rem-avatar src='${this.src}' alt='${this.emoji}' size='large'></rem-avatar>
    `
  }

  static styles = css`
    :host {
      position: relative;
    }

    span {
      position: absolute;
      right: 0;
      bottom: 0;
      line-height: var(--op-line-height-densest);

      z-index: 2;
    }

    rem-avatar {
      z-index: 1;
    }
  `
}
