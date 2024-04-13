# frozen_string_literal: true

module LycanUi
  module Generators
    class SetupGenerator < Rails::Generators::Base
      class InvalidInstallationTypeError < StandardError; end

      def detect_installation_type
        # TODO: other installation types, bun, esbuild, etc.

        @use_importmap = File.exist?("config/importmap.rb")
        @use_postcss =  File.exist?("tailwind.config.js")
        @use_sprockets = Object.const_defined?("Sprockets")
      end

      def install_for_type
        install_importmap if @use_importmap

        install_sprockets if @use_sprockets
      end

      def install_assets_path
        return if @use_postcss

        insert_into_file(
          "config/initializers/assets.rb",
          "Rails.application.config.assets.paths << Rails.root.join('app', 'components')")
      end

      def install_tailwind_config
        if @use_postcss
          insert_into_file(
            "tailwind.config.js",
            ",\n    './app/components/**/*.{rb,erb,haml,html,slim}',",
            after:  "    './app/javascript/**/*.js'",
          )
        else
          insert_into_file(
            "config/tailwind.config.js",
            ",\n    './app/components/**/*.{rb,erb,haml,html,slim}',",
            after:  "    './app/views/**/*.{erb,haml,html,slim}'",
          )

          gsub_file("config/tailwind.config.js", "require('@tailwindcss/forms'),", "")
        end
      end

      def install_gem
        %x(bundle add view_component)
      end


      private

      def install_importmap
        insert_into_file("config/importmap.rb", <<~RB
            components_path = Rails.root.join('app/components')
            components_path.glob('**/*_controller.js').each do |controller|
              name = controller.relative_path_from(components_path).to_s.remove(/\\.js$/)
              pin "controllers/\#{name}", to: name, preload: false
            end
          RB
        )
      end

      def install_sprockets
        insert_into_file("app/assets/config/manifest.js", "//= link_tree ../../components .js")
      end
    end
  end
end
