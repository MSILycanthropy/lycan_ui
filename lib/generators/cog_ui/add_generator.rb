# frozen_string_literal: true

module CogUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_helpers
        copy_file("lib/attributes_helper.rb", "lib/cog_ui/attributes_helper.rb", skip: true)
        copy_file("lib/classes_helper.rb", "lib/cog_ui/classes_helper.rb", skip: true)
        copy_file("lib/validations_helper.rb", "lib/cog_ui/validations_helper.rb", skip: true)
      end

      def create_base_component
        empty_directory("app/components", skip: true)
        copy_file("components/component.rb", "app/components/cog_ui_component.rb", skip: true)
      end

      def create_component
        class_name = file_name.classify
        file_name = class_name.underscore

        template("components/#{file_name}.rb", "app/components/#{file_name}.rb")

        create_ruby_deps(file_name)
      end

      def create_javascript
        class_name = file_name.classify
        file_name = class_name.underscore

        template("javascript/#{file_name}_controller.js", "app/components/#{file_name}_controller.js")

        create_javascript_deps(file_name)
      end

      private

      def create_ruby_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/components/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}/", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", skip: true)
            else
              template(template_name, "app/#{template_name}", skip: true)
            end
          end
        end
      end

      def create_javascript_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/javascript/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", skip: true)
            else
              output_name = template_name.sub("javascript/", "components/")
              template(template_name.sub("/", ""), "app/#{output_name}", skip: true)
            end
          end
        end
      end
    end
  end
end
