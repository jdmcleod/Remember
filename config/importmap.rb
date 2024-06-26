pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"

pin "trix"
pin "@rails/actiontext", to: "@rails--actiontext.js" # @7.0.8

pin "application", preload: true

pin "stimulus-use" # @0.52.2

# Lit
pin "lit", to: "https://esm.run/lit" # @3.1.4
