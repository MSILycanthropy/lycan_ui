# frozen_string_literal: true

module CogUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :force, type: :boolean, default: false

      def set_options
        @copy_opts = options[:force] ? { force: true } : { skip: true }
      end

      def create_helpers
        copy_file("lib/attributes_helper.rb", "lib/cog_ui/attributes_helper.rb", **@copy_opts)
        copy_file("lib/classes_helper.rb", "lib/cog_ui/classes_helper.rb", **@copy_opts)
        copy_file("lib/validations_helper.rb", "lib/cog_ui/validations_helper.rb", **@copy_opts)
      end

      def create_base_component
        empty_directory("app/components", **@copy_opts)
        copy_file("components/component.rb", "app/components/cog_ui_component.rb", **@copy_opts)
      end

      def create_component
        class_name = file_name.classify
        file_name = class_name.downcase.underscore

        if file_name == "all"
          generate_all
          return
        end

        generate(class_name, file_name)
      end

      private

      def generate_all
        source_paths.each do |source|
          Dir["#{source}/components/*.rb"].each do |file|
            template_name = file.gsub("#{source}/", "")
            class_name = File.basename(file, ".rb").classify
            file_name = class_name.downcase.underscore

            generate(class_name, file_name)
          end
        end
      end

      def generate(class_name, file_name)
        template("components/#{file_name}.rb", "app/components/#{file_name}.rb")

        create_ruby_deps(file_name)

        js_file_exists = source_paths.any? do |source|
          File.exist?("#{source}/javascript/#{file_name}_controller.js")
        end

        return unless js_file_exists

        template("javascript/#{file_name}_controller.js", "app/components/#{file_name}_controller.js")

        create_javascript_deps(file_name)
      end


      def create_ruby_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/components/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}/", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", **@copy_opts)
            else
              template(template_name, "app/#{template_name}", **@copy_opts)
            end
          end
        end
      end

      def create_javascript_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/javascript/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", **@copy_opts)
            else
              output_name = template_name.sub("javascript/", "components/")
              template(template_name.sub("/", ""), "app/#{output_name}", **@copy_opts)
            end
          end
        end
      end
    end
  end
end
