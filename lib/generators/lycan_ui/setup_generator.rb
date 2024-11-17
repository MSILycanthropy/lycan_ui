# frozen_string_literal: true

module LycanUi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("templates/setup", __dir__)

      def copy_helpers
        copy_file("helpers.rb", "app/helpers/lycan_ui_helper.rb")
      end

      def install_tailwind_css_animate
        if importmaps?
          copy_file("importmaps/tailwind.config.js", "config/tailwind.config.js", force: true)
        else
          raise "Non-importmaps setup currently doesn't work :("
        end
      end

      private

      def importmaps?
        File.exist?("#{Rails.root}/config/importmap.rb")
      end
    end
  end
end
