pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/web-components", under: "web-components"

pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "application", preload: true
pin "stimulus-use" # @0.52.2
pin "@rolemodel/turbo-confirm"
pin "hotkeys-js" # @3.13.7
pin "stimulus-use/hotkeys", to: "stimulus-use--hotkeys.js" # @0.52.2
pin "lit", to: "https://cdn.jsdelivr.net/npm/lit@latest/+esm"
pin "trix"
