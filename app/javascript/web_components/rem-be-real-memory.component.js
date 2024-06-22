import { LitElement, css, html } from "lit"

export default class REMBeRealMemory extends LitElement {
  //   drawingEditor: { type: Object, fromLCADContext: true, state: true },
  //   activePerspective: { type: String, fromLCADContext: true, state: true }
  static properties = {
    memory: { type: Object },
    swapped: { type: Boolean, state: true }
  }

  constructor() {
    super()
    this.memory = {}
    this.swapped = false
  }

  #swapImages() {
    this.swapped = !this.swapped
  }

  // #mouseDown(event) {
  //   // event = event || window.event
  //   event.preventDefault()

  //   const xPosition = event.clientX;
  //   const yPosition = event.clientY;

  //   this.onmousemove = (e) => {
  //     console.log('mouse move', e.clientX, e.clientY)
  //   }
  // }

  // #mouseUp(event) {
  //   event.preventDefault()

  //   this.onmousemove = null
  // }

  render() {
    const images = [this.memory.primary, this.memory.secondary]
    if (this.swapped) {
      images.reverse()
    }

    return html`
      <img src="${images[0].url}" alt="${this.memory.memory_day}" class="primary">
      <img
        src="${images[1].url}"
        alt="${this.memory.memory_day}"
        class="secondary"
        @click="${this.#swapImages}"
      >
    `
  }

  static styles = css`
    :host {
      --primary-height: calc(var(--op-size-unit) * 100); /* 400px */
      --secondary-height: calc(var(--op-size-unit) * 30); /* 120px */

      position: relative;
      display: block;
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
