# frozen_string_literal: true

module LycanUi
  class Component
    attr_accessor :attributes
    delegate_missing_to :@view_context

    def initialize(attributes = {}, **default_attributes)
      @attributes = merge_attributes(attributes, **default_attributes)
    end

    def render_in(view_context, &)
      @view_context = view_context

      template(&)
    ensure
      @view_context = nil
    end

    def template
      raise NotImplementedError
    end

    private

    def merge_attributes(*incoming, **default)
      default.merge(*incoming) do |key, default_value, incoming_value|
        case key
        when :class
          merge_classes(default_value, incoming_value)
        when :data
          merge_data(default_value, incoming_value)
        when :aria
          merge_aria(default_value, incoming_value)
        else
          incoming_value
        end
      end
    end

    def merge_classes(*classes)
      @@merger ||= TailwindMerge::Merger.new
      @@merger.merge(classes)
    end

    def merge_data(*hashes)
      hashes.compact.each_with_object({}) do |hash, result|
        result.deep_merge(hash) do |key, old_value, new_value|
          case key
          when :action, :controller
            [ old_value, new_value ].compact.join(" ")
          else
            new_value
          end
        end
      end
    end

    def merge_aria(*hashes)
      hashes.compact.each_with_object({}) do |hash, result|
        result.deep_merge(hash)
      end
    end

    def determine_content(text = nil, &)
      return text if text.present?
      return unless block_given?

      @view_context.capture(&)
    end
  end
end
