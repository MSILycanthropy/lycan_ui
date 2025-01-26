# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      alias_method :component, :file_name

      def install_form
        return unless file_name == "form"

        copy_file("extras/form_builder.rb", "app/lib/lycan_ui/form_helper.rb")
        insert_into_file(
          "app/lib/lycan_ui/helpers.rb",
          "    include LycanUi::FormHelper\n",
          after: "    include LycanUi::ClassesHelper\n",
        )

        [ "label", "input", "textarea", "checkbox", "button", "radio", "switch" ].each do |comp|
          puts "Installing #{comp.titleize}..."
          %x(rails g lycan_ui:add #{comp})
        end

        exit
      end

      def copy_views
        copy_file("views/_#{component}.html.erb", "app/views/ui/_#{component}.html.erb")
        directory("views/#{component}", "app/views/ui/#{component}") if dir_exists?("views/#{component}")
      end

      def copy_js
        if file_exists?("javascript/#{component}_controller.js")
          copy_file("javascript/#{component}_controller.js", "app/javascript/controllers/#{component}_controller.js")
        end

        if dir_exists?("javascript/#{component}")
          directory("javascript/#{component}", "app/javascript/controllers/#{component}")
        end

        unless importmaps?
          content = <<~JS

            import #{component.titleize}Controller from "./#{component}_controller"
            application.register("#{component}", #{component.titleize}Controller)
          JS
          append_to_file("app/javascript/controllers/index.js", content)
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

      def importmaps?
        File.exist?("#{Rails.root}/config/importmap.rb")
      end
    end
  end
end
