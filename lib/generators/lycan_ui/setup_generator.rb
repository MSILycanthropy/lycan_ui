# frozen_string_literal: true

module LycanUi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("templates/setup", __dir__)

      def copy_helpers
        copy_file("helpers.rb", "app/helpers/lycan_ui_helper.rb")
      end
    end
  end
end
