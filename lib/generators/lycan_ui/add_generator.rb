# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      alias_method :component, :file_name

      def copy_views
        directory("views/#{component}", "app/views/ui/#{component}")
      end
    end
  end
end
