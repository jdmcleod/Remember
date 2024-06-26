import { LitElement, css, html } from "lit"

export default class REMBeRealMemory extends LitElement {
  static properties = {
    date: { type: String },
    primarySrc: { type: String },
    secondarySrc: { type: String },
    swapped: { type: Boolean, state: true },
    dragging: { type: Boolean, state: true },
  }

  constructor() {
    super()
    this.date = ''
    this.primarySrc = ''
    this.secondarySrc = ''
    this.swapped = false
    this.dragging = false
  }

  get secondary() {
    return this.shadowRoot.getElementById('secondary')
  }

  setupDrag(event) {
    event.preventDefault()

    document.onmousemove = this.elementDrag.bind(this)
    document.onmouseup = this.finishDrag.bind(this)
  }

  elementDrag(event) {
    this.dragging = true
    const overallRectangle = this.getBoundingClientRect()
    const secondaryRectangle = this.secondary.getBoundingClientRect()

    const topPosition = event.clientY - overallRectangle.y - (secondaryRectangle.height / 2)
    const topLimit = overallRectangle.height - secondaryRectangle.height

    const leftPosition = event.clientX - overallRectangle.x - (secondaryRectangle.width / 2)
    const leftLimit = overallRectangle.width - secondaryRectangle.width

    this.secondary.style.top = Math.min(Math.max(topPosition, 0), topLimit) + 'px'
    this.secondary.style.left = Math.min(Math.max(leftPosition, 0), leftLimit) + 'px'
  }

  finishDrag() {
    document.onmousemove = null
    document.onmouseup = null

    this.secondary.style.top = '16px'
    this.secondary.style.left = '16px'
  }

  #handleClick() {
    if (!this.dragging) {
      this.swapped = !this.swapped
    }

    this.dragging = false
  }

  render() {
    const images = [this.primarySrc, this.secondarySrc]

    if (this.swapped) {
      images.reverse()
    }

    return html`
      <img src="${images[0]}" alt="${this.date}" class="primary">
      <img
        id="secondary"
        src="${images[1]}"
        alt="${this.date}"
        class="secondary"
        @click="${this.#handleClick}"
        @mousedown="${this.setupDrag}"
      >
    `
  }

  static styles = css`
    :host {
      --primary-height: calc(var(--op-size-unit) * 100); /* 400px */
      --secondary-height: calc(var(--op-size-unit) * 30); /* 120px */

      position: relative;
      display: block;
      height: var(--primary-height);

      overflow: hidden;
    }

    img {
      aspect-ratio: 3 / 4;
      border-radius: var(--op-radius-2x-large);
    }

    .primary {
      height: var(--primary-height);
      z-index: 1;
    }

    .secondary {
      position: absolute;
      top: var(--op-space-medium);
      left: var(--op-space-medium);

      height: var(--secondary-height);

      border: var(--op-border-width-large) solid var(--op-color-neutral-minus-max);
      cursor: pointer;
      z-index: 2;
    }
  `
}
