import { css, html } from "lit"
import REMBeRealMemory from 'web-components/rem-be-real-memory.component'

export default class REMYearHighlight extends REMBeRealMemory {
  render() {
    const images = [this.primarySrc]

    let size = this.size

    if (this.expanded) {
      size = 100
    }

    const height = `calc(var(--op-size-unit) * ${size})`

    return html`
      <div class="placeholder ${!this.expanded ? 'hide' : ''}" @click=${this._expandImage}>
        <ti-icon name='camera' class="placeholder__icon"></ti-icon>
      </div>
      <img src="${images[0]}" @click="${this._expandImage}" alt="${this.date}" class="${this.expanded ? 'expanded' : ''}" style="width: ${height};">
      <slot name="actions" class="${!this.expanded ? 'hide' : ''}"></slot>
    `
  }

  static styles = css`
    :host {
      position: relative;
      display: block;
    }

    .placeholder {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 3rem;
      height: 3rem;
      background-color: var(--op-color-primary-base);
      color: var(--op-color-neutral-plus-max);
      border-radius: var(--op-radius-medium);
      box-sizing: border-box;

      ti-icon {
        --font-size: var(--op-font-large);
      }
    }

    img {
      border-radius: var(--op-radius-large);
      border: var(--op-border-width-large) solid var(--op-color-neutral-plus-seven);
      &:hover {
        border: var(--op-border-width-large) solid black;
        cursor: pointer;
      }
    }
    
    .expanded {
      position: absolute;
      top: 30px;
    }
      
    .hide {
      display: none;
    }
  `
}
