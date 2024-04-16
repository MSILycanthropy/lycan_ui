# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :force, type: :boolean, default: false

      def detect_installation_type
        @use_importmap = File.exist?("config/importmap.rb")
        @use_node = File.exist?("tailwind.config.js")
      end

      def set_options
        @opts = options[:force] ? { force: true } : { skip: true }
      end

      def create_helpers
        copy_file("lib/attributes_helper.rb", "lib/lycan_ui/attributes_helper.rb", **@opts)
        copy_file("lib/classes_helper.rb", "lib/lycan_ui/classes_helper.rb", **@opts)
        copy_file("lib/validations_helper.rb", "lib/lycan_ui/validations_helper.rb", **@opts)
      end

      def create_base_component
        empty_directory("app/components", **@opts)
        copy_file("components/component.rb", "app/components/lycan_ui_component.rb", **@opts)
      end

      def create_component
        if file_name == "all"
          generate_all
          return
        end

        generate(file_name)
        generate_dependencies(file_name)
      end

      private

      def generate_all
        source_paths.each do |source|
          Dir["#{source}/components/*.rb"].each do |file|
            template_name = file.gsub("#{source}/", "")
            file_name = File.basename(file, ".rb").downcase.underscore

            generate(file_name)
            generate_dependencies(file_name)
          end
        end
      end

      def generate(file_name)
        class_name = file_name.to_s.classify

        template("components/#{file_name}.rb", "app/components/#{file_name}.rb")

        create_ruby_deps(file_name)

        create_css_deps(file_name)

        js_file_exists = source_paths.any? do |source|
          File.exist?("#{source}/javascript/#{file_name}_controller.js")
        end

        return unless js_file_exists

        template("javascript/#{file_name}_controller.js", "app/components/#{file_name}_controller.js")

        unless @use_importmap
          append_to_file(
            "app/javascript/controllers/index.js",
            "\nimport #{file_name.camelcase} from \"../../components/#{file_name}_controller.js\"\n",
          )

          append_to_file(
            "app/javascript/controllers/index.js",
            "application.register(\"#{file_name.dasherize}\", #{file_name.camelcase})\n",
          )
        end

        create_javascript_deps(file_name)
      end

      DEPENDENCIES = { alert_dialog: [ :button ] }.with_indifferent_access.freeze
      def generate_dependencies(file_name)
        file_names = DEPENDENCIES[file_name]

        return if file_names.blank?

        file_names.each do |file_name|
          generate(file_name)
        end
      end


      def create_ruby_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/components/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}/", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", **@opts)
            else
              template(template_name, "app/#{template_name}", **@opts)
            end
          end
        end
      end

      def create_javascript_deps(file_name)
        source_paths.each do |source|
          Dir["#{source}/javascript/#{file_name}/**/*"].each do |file|
            template_name = file.gsub("#{source}", "")

            if File.directory?(file)
              empty_directory("app/#{template_name}", **@opts)
            else
              output_name = template_name.sub("javascript/", "components/")
              template(template_name.sub("/", ""), "app/#{output_name}", **@opts)

              controller_name = output_name
                .sub("/components/", "")
                .gsub("/", "__")
                .gsub(".js", "")
                .sub("_controller", "")


              unless @use_importmap
                append_to_file(
                  "app/javascript/controllers/index.js",
                  "\nimport #{controller_name.camelcase} from \"../..#{output_name}\"\n",
                )

                append_to_file(
                  "app/javascript/controllers/index.js",
                  "application.register(\"#{controller_name.dasherize}\", #{controller_name.camelcase})\n",
                )
              end
            end
          end
        end
      end

      def create_css_deps(file_name)
        css_exists = source_paths.any? do |source|
          File.exist?("#{source}/css/#{file_name}.css")
        end

        return unless css_exists

        template("css/#{file_name}.css", "app/components/#{file_name}.css")

        if @use_node
          prepend_to_file(
            "app/assets/stylesheets/application.tailwind.css",
            "@import \"../../components/#{file_name}.css\";\n",
          )
        else
          insert_into_file("app/assets/stylesheets/application.tailwind.css", "@import \"#{file_name}.css\";\n")
        end
      end
    end
  end
end
