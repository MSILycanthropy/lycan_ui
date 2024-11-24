# frozen_string_literal: true

require "tty-prompt"

module LycanUi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("templates/setup", __dir__)

      def install_tailwind_merge
        return unless tailwind?
        return if tailwind_merge_installed?

        run("bundle add tailwind_merge")
      end

      def install_tailwind_config
        return unless tailwind?

        if importmaps?
          copy_file("tailwind.config.js", "config/tailwind.config.js", force: true)
        else
          copy_file("tailwind.config.js", "tailwind.config.js", force: true)
        end
      end

      def copy_helpers
        copy_file("attributes_helper.rb", "app/helpers/attributes_helper.rb")
        template("classes_helper.rb.tt", "app/helpers/classes_helper.rb")

        enhanced = yes?("Would you like the `ui` helper method for ease of use? (y/n)")

        if enhanced
          copy_file("lycan_ui_helper_enhanced.rb", "app/helpers/lycan_ui_helper.rb")
        else
          copy_file("lycan_ui_helper.rb", "app/helpers/lycan_ui_helper.rb")
        end
      end

      def install_components
        prompt = TTY::Prompt.new
        path = source_paths.first.sub("/setup", "/views")
        choices = Dir.glob("#{path}/*.html.erb").map do |c|
          c.sub(path, "").sub(".html.erb", "").gsub("_", " ").slice(1..).strip
        end.index_by { |comp| comp.titleize }

        selected = prompt.multi_select("Select your options:", choices, filter: true, cycle: true)

        selected.each do |component|
          puts "Installing #{component.titleize}..."
          %x(rails g lycanui:add #{component} --force)
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
