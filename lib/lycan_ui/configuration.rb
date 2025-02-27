# frozen_string_literal: true

module LycanUi
  class Configuration
    DEFAULT_JAVASCRIPT_DIR = "app/javascript/controllers"

    class << self
      attr_accessor :stylesheet, :javascript_dir

      def setup
        json = {}

        if File.exist?("#{Rails.root}/config/lycan_ui.json")
          json = JSON.parse(File.read("#{Rails.root}/config/lycan_ui.json"))
        end

        self.stylesheet = json["stylesheet"] || default_stylesheet
        self.javascript_dir = json["javascript_dir"] || DEFAULT_JAVASCRIPT_DIR
      end

      private

      def default_stylesheet
        if File.exist?("#{Rails.root}/app/assets/stylesheets/application.tailwind.css")
          return "app/assets/stylesheets/application.tailwind.css"
        end

        "app/assets/tailwind/application.css"
      end
    end
  end
end
