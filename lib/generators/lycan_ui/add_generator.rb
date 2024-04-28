# frozen_string_literal: true

module LycanUi
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :force, type: :boolean, default: false

      def detect_installation_type
        @use_node = File.exist?("tailwind.config.js")
        @use_sprockets = Object.const_defined?("Sprockets")
      end

      def set_options
        @opts = options[:force] ? { force: true } : { skip: true }
      end

      def create_component
        if file_name == "all"
          generate_all
          return
        end

        generate(file_name)
        generate_dependencies(file_name)
      end

      REQUIRES_HOVER = [ :popover, :all ]
      def add_floating_ui
        return if REQUIRES_HOVER.exclude?(file_name.to_sym)

        if @use_node
          installed_already = File.read("package.json").match?("@floating-ui/dom")

          return if installed_already

          puts "Installing @floating-ui/dom..."

          %x(yarn add @floating-ui/dom)
        else
          installed_already = File.read("config/importmap.rb").match?("@floating-ui/dom")

          return if installed_already

          puts "Installing @floating-ui/dom..."

          %x(bin/importmap pin @floating-ui/dom)
        end
      end

      def add_focus_trap
        return if REQUIRES_HOVER.exclude?(file_name.to_sym)

        if @use_node
          installed_already = File.read("package.json").match?("focus-trap")

          return if installed_already

          puts "Installing focus-trap..."

          %x(yarn add focus-trap)
        else
          installed_already = File.read("config/importmap.rb").match?("focus-trap")

          return if installed_already

          puts "Installing focus-trap..."

          %x(bin/importmap pin focus-trap)
        end
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

        if @use_node
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

      DEPENDENCIES = {
        alert_dialog: [ :button ],
        popover: [ :button ],
        form: [
          :label,
          :input,
          :pin_input,
          :switch,
          :text_area,
          :checkbox,
          :radio,
          :button,
        ],
      }.with_indifferent_access.freeze
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


              if @use_node
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

        if @use_sprockets
          if @use_node
            prepend_to_file(
              "app/assets/stylesheets/application.tailwind.css",
              "@import \"../../components/#{file_name}.css\";\n",
            )
          else
            insert_into_file("app/assets/stylesheets/application.tailwind.css", "@import \"#{file_name}.css\";\n")
          end
        else
          if @use_node
            prepend_to_file(
              "app/assets/stylesheets/application.tailwind.css",
              "@import \"../../components/#{file_name}.css\";\n",
            )
          else
            insert_into_file("app/assets/stylesheets/application.css", "@import url(\"#{file_name}.css\");\n")
          end
        end
      end
    end
  end
end
