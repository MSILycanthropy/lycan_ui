# frozen_string_literal: true

require "lycan_ui/configuration"

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      REQUIRES_FLOATING = [ "dropdown" ].freeze

      alias_method :component, :file_name

      def load_configuration
        Configuration.setup
      end

      def install_form
        return unless component == "form"

        copy_file("extras/form_builder.rb", "app/helpers/lycan_ui/form_helper.rb")

        [ "label", "input", "textarea", "checkbox", "button", "radio", "switch" ].each do |comp|
          puts "Installing #{comp.titleize}..."
          %x(rails g lycan_ui:add #{comp} --force)
        end

        exit
      end

      def copy_views
        copy_file("components/#{component}.rb", "app/components/lycan_ui/#{component}.rb")
      end

      def copy_js
        if file_exists?("javascript/#{component}_controller.js")
          copy_file("javascript/#{component}_controller.js", "#{Configuration.javascript_dir}/#{component}_controller.js")
        end

        if dir_exists?("javascript/#{component}")
          directory("javascript/#{component}", "#{Configuration.javascript_dir}/#{component}")
        end

        unless importmaps?
          content = <<~JS

            import #{component.titleize}Controller from "./#{component}_controller"
            application.register("#{component}", #{component.titleize}Controller)
          JS
          append_to_file("#{Configuration.javascript_dir}/index.js", content)
        end
      end

      def install_floating
        return unless floating?

        js_command = if importmaps?
          "bin/importmaps pin @floating-ui/dom"
        else
          "yarn add @floating-ui/dom"
        end

        run(js_command)
      end

      private

      def floating?
        REQUIRES_FLOATING.include?(component)
      end

      def dir_exists?(name)
        root = source_paths.first

        Dir.exist?("#{root}/#{name}")
      end

      def file_exists?(name)
        root = source_paths.first

        File.exist?("#{root}/#{name}")
      end

      def importmaps?
        File.exist?("#{Rails.root}/config/importmap.rb")
      end
    end
  end
end
