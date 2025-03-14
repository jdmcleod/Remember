import { LitElement, css, html } from "lit"

export default class REMBeRealMemory extends LitElement {
  static properties = {
    date: { type: String },
    primarySrc: { type: String },
    secondarySrc: { type: String },
    size: { type: Number },
    swapped: { type: Boolean, state: true },
    dragging: { type: Boolean, state: true },
    expanded: { type: Boolean, state: false },
    disableExpand: { type: Boolean, state: false }
  }

  constructor() {
    super()
    this.date = ''
    this.primarySrc = ''
    this.size = 100
    this.secondarySrc = ''
    this.swapped = false
    this.dragging = false
    this.expanded = false
    this.disableExpand = false
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

  _expandImage() {
    if (this.disableExpand) return

    this.expanded = !this.expanded
  }

  _handleClick() {
    if (!this.dragging) {
      this.swapped = !this.swapped
    }

    this.dragging = false
  }

  _renderSecondary(height, image) {
    if (this.secondarySrc) {
      return html`
        <img
          id="secondary"
          src="${image}"
          alt="${this.date}"
          style="width: ${height};"
          class="secondary"
          @click="${this._handleClick}"
          @mousedown="${this.setupDrag}"
        >
      `
    }
  }

  render() {
    const images = [this.primarySrc]
    if (this.secondarySrc) images.push(this.secondarySrc)

    if (this.swapped) {
      images.reverse()
    }

    let size = this.size

    if (this.expanded) {
      size = 120
    }

    const classes = `primary ${this.expanded ? 'expanded' : ''}`

    const primaryHeight = `calc(var(--op-size-unit) * ${size})`
    const secondaryHeight = `calc(var(--op-size-unit) * ${size / 3.34})`
    return html`
      <img src="${images[0]}" @click="${this._expandImage}" alt="${this.date}" class="${classes}" style="width: ${primaryHeight};">
      
      ${this._renderSecondary(secondaryHeight, images[1])}
      <slot name="actions"></slot>
    `
  }

  static styles = css`
    :host {
      position: relative;
      display: block;
      overflow: hidden;
    }

    img {
      border-radius: var(--op-radius-large);
      border: var(--op-border-width-large) solid var(--op-color-neutral-plus-seven);
      &:hover {
        border: var(--op-border-width-large) solid black;
        cursor: pointer;
      }
    }

    .primary {
      z-index: 1;
    }
    
    .expanded {
      position: fixed;
      bottom: 30px;
    }

    .secondary {
      position: absolute;
      top: var(--op-space-medium);
      left: var(--op-space-medium);

      border: var(--op-border-width-large) solid var(--op-color-neutral-minus-max);
      cursor: pointer;
      z-index: 2;
    }
  `
}
