# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      alias_method :component, :file_name

      def copy_views
        copy_file("views/_#{component}.html.erb", "app/views/ui/_#{component}.html.erb")
        directory("views/#{component}", "app/views/ui/#{component}") if Dir.exist?("app/views/ui/#{component}")
      end

      def copy_js
        copy_file("javascript/#{component}_controller.js", "app/javascript/controllers/ui/#{component}_controller.js")

        if Dir.exist?("app/javascript/controllers/ui/#{component}")
          directory("javascript/#{component}", "app/javascript/controllers/ui/#{component}")
        end
      end
    end
  end
end
