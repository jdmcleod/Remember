import { LitElement, html, css } from 'lit'

export default class TiIcon extends LitElement {
  static properties = {
    name: { type: String },
    size: { type: String },
  }

  constructor() {
    super()

    this.size = 'medium'
  }

  render() {
    return html`
      <link
        rel="stylesheet"
        type="text/css"
        href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css"
      />
      <i class="icon ti ti-${this.name}"></i>
    `
  }

  static styles = css`
    :host {
      --font-size: var(--op-font-medium);

      display: flex;
      align-items: center;
      font-size: var(--font-size);
    }

    // Size
    :host([size='x-small']) {
      --font-size: var(--op-font-x-small);
    }

    :host([size='small']) {
      --font-size: var(--op-font-small);
    }

    :host([size='medium']) {
      --font-size: var(--op-font-medium);
    }

    :host([size='large']) {
      --font-size: var(--op-font-large);
    }

    :host([size='x-large']) {
      --font-size: var(--op-font-x-large);
    }
    
    :host([size='supa-large']) {
      --font-size: 10rem;
    }
  `
}
