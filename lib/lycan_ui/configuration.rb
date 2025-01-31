# frozen_string_literal: true

module LycanUi
  class Configuration
    DEFAULT_STYLESHEET = "app/assets/stylesheets/application.tailwind.css"
    DEFAULT_JAVASCRIPT_DIR = "app/javascript/controllers"

    class << self
      attr_accessor :stylesheet, :javascript_dir

      def setup
        json = {}

        if File.exist?("#{Rails.root}/config/lycan_ui.json")
          json = JSON.parse(File.read("#{Rails.root}/config/lycan_ui.json"))
        end

        self.stylesheet = json["stylesheet"] || DEFAULT_STYLESHEET
        self.javascript_dir = json["javascript_dir"] || DEFAULT_JAVASCRIPT_DIR
      end
    end
  end
end
