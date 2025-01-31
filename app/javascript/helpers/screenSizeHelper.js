const breakpointSmallSize = () => parseInt(getComputedStyle(document.body).getPropertyValue('--op-breakpoint-small'), 10)

const breakpointMediumSize = () => parseInt(getComputedStyle(document.body).getPropertyValue('--op-breakpoint-medium'), 10)

const isMobileSizeEvent = () => window.matchMedia(`(max-width: ${breakpointSmallSize()}px)`) // Use this for a window resize event.

const isMobile = () => window.matchMedia(`(max-width: ${breakpointSmallSize()}px)`).matches

const verticalTabletScreen = () => window.matchMedia(`(max-width: ${breakpointMediumSize()}px)`).matches

export {
  isMobile,
  verticalTabletScreen,
  breakpointSmallSize,
  breakpointMediumSize,
  isMobileSizeEvent
}
