# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      alias_method :component, :file_name

      def copy_views
        copy_file("views/_#{component}.html.erb", "app/views/ui/_#{component}.html.erb")
        directory("views/#{component}", "app/views/ui/#{component}") if dir_exists?("views/#{component}")
      end

      def copy_js
        if file_exists?("javascript/#{component}_controller.js")
          copy_file("javascript/#{component}_controller.js", "app/javascript/controllers/ui/#{component}_controller.js")
        end

        if dir_exists?("javascript/#{component}")
          directory("javascript/#{component}", "app/javascript/controllers/ui/#{component}")
        end
      end

      private

      def dir_exists?(name)
        root = source_paths.first

        Dir.exist?("#{root}/#{name}")
      end

      def file_exists?(name)
        root = source_paths.first

        File.exist?("#{root}/#{name}")
      end
    end
  end
end
