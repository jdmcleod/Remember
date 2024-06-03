pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"

# pin "animate.css" # @4.1.1
pin "trix"
pin "@rails/actiontext", to: "@rails--actiontext.js" # @7.0.8

pin "application", preload: true

