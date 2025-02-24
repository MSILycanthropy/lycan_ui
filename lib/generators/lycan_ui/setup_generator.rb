# frozen_string_literal: true

require "tty-prompt"
require "lycan_ui/configuration"


module LycanUi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def load_configuration
        Configuration.setup
      end

      def install_tailwind_merge
        return unless tailwind?
        return if tailwind_merge_installed?

        run("bundle add tailwind_merge")
      end

      def install_tailwind_config
        return unless tailwind?

        template("setup/application.tailwind.css", Configuration.stylesheet, force: true)
      end

      def copy_helpers
        copy_file("setup/lycan_ui_helper.rb", "app/helpers/lycan_ui_helper.rb")
      end

      # TODO: add `all`
      def install_components
        copy_file("components/component.rb", "app/components/lycan_ui/component.rb")

        prompt = TTY::Prompt.new
        path = source_paths.first + "/components"
        choices = Dir.glob("#{path}/*.rb").map do |c|
          c.sub(path, "").sub(".rb", "").gsub("_", " ").slice(1..).strip
        end.reject { it == "component" }.push("form").sort.index_by { |comp| comp.titleize }

        selected = prompt.multi_select("Select your options:", choices, filter: true)

        selected.each do |component|
          puts "Installing #{component.titleize}..."
          %x(rails g lycan_ui:add #{component} --force)
        end
      end

      private

      def tailwind_merge_installed?
        Gem.loaded_specs.key?("tailwind_merge")
      end

      def tailwind?
        true
      end

      def importmaps?
        File.exist?("#{Rails.root}/config/importmap.rb")
      end
    end
  end
end
