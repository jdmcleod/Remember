export function setElementLocation(element, left, top) {
  element.style.left = numberToPixels(left)
  element.style.top = numberToPixels(top)
}

export function createElement(rootElement, tagName, className) {
  const element = rootElement.appendChild(document.createElement(tagName))
  if (className) { element.className = className }
  return element
}

export function numberToPixels(number) {
  return number + 'px'
}

export function toggleVisible(element, override) {
  if (!element) return
  const isVisible = !element.classList.contains('visibility-hidden')
  if (override === isVisible) return
  console.log('removing class', element)
  element.classList.toggle('visibility-hidden', isVisible)
}

export function toggleDisplayed(element, override) {
  if (!element) return
  const isDisplayed = !element.classList.contains('hidden')
  if (typeof override === 'boolean' && isDisplayed === override) return
  element.classList.toggle('hidden')
}

export function animate(node, animationName, timeUntilRemove = 1000) {
  node.classList.add('animate__animated')
  node.classList.add(`animate__${animationName}`)

  setTimeout(() => {
    node.classList.remove('animate__animated')
    node.classList.remove(`animate__${animationName}`)
  }, timeUntilRemove)
}
