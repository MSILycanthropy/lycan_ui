# frozen_string_literal: true

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "assets/javascripts/controllers", under: "controllers"
pin_all_from "../lib/generators/lycan_ui/templates/javascript"
pin "@floating-ui/core", to: "@floating-ui--core.js" # @1.6.9
pin "@floating-ui/dom", to: "@floating-ui--dom.js" # @1.6.13
pin "@floating-ui/utils", to: "@floating-ui--utils.js" # @0.2.9
pin "@floating-ui/utils/dom", to: "@floating-ui--utils--dom.js" # @0.2.9
pin "focus-trap" # @7.6.4
pin "tabbable" # @6.2.0
