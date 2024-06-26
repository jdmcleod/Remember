import { LitElement, css, html } from "lit"

export default class REMAvatar extends LitElement {
  static properties = {
    src: { type: String },
    alt: { type: String },
    size: { type: String, reflect: true }
  }

  constructor() {
    super()
    this.src = ''
    this.alt = 'Avatar'
    this.size = 'medium'
  }

  render() {
    return html`
      <img src='${this.src}' alt='${this.alt}'>
    `
  }

  static styles = css`
    :host {
      --size: calc(10 * var(--op-size-unit));
      --radius: var(--op-radius-circle);

      position: relative;
      z-index: 1;
      display: block;
      overflow: hidden;
      width: var(--size);
      min-width: var(--size);
      height: var(--size);
      min-height: var(--size);
      border-radius: var(--radius);
    }

    :host([size='small']) {
      --size: calc(8 * var(--op-size-unit))
    }

    :host([size='medium']) {
      --size: calc(10 * var(--op-size-unit));
    }

    :host([size='large']) {
      --size: calc(14 * var(--op-size-unit))
    }

    :host::before {
      position: absolute;
      z-index: 2;
      content: "";
      inset: 0;
    }

    :host::after {
      position: absolute;
      z-index: 3;
      border-radius: var(--radius);
      box-shadow: inset 0 0 0 var(--op-border-width-large) var(--op-color-neutral-base),
        inset 0 0 0 calc(var(--op-border-width) + var(--op-border-width-large)) var(--op-color-neutral-minus-max);
      content: "";
      inset: 0;
    }

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  `
}
