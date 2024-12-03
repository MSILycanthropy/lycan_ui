# frozen_string_literal: true

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "assets/javascripts/controllers", under: "controllers"
pin_all_from "../lib/generators/lycan_ui/templates/javascript"
