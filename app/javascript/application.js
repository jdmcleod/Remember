// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@hotwired/turbo-rails"
// import * as ActiveStorage from "@rails/activestorage"
import "controllers"
import "web_components"

import "trix"
import "@rails/actiontext"

// import './initializers/turbo_confirm'
// import './initializers/frame_missing_handler.js'

// Rails.start()
// ActiveStorage.start()

// Correctly handle redirects after modal form submission.
// Required in Turbo 7.3.0 (turbo-rails 1.4.0) and above.
// See https://github.com/hotwired/turbo/pull/863 for details.
document.addEventListener("turbo:frame-missing", (event) => {
  if (event.target.id === "modal") {
    event.preventDefault()
    event.detail.visit(event.detail.response.url)
  }
})
