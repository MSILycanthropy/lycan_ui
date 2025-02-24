# frozen_string_literal: true

module LycanUiHelper
  COMPONENTS = Dir.glob(Rails.root.join("app/components/lycan_ui/*.rb"))
    .map { |c| c.split("/").last.sub(".rb", "") }
    .index_by(&:itself)
    .transform_values { "LycanUi::#{it.classify}".constantize }
    .symbolize_keys
    .freeze

  class Builder
    def initialize(view_context)
      @view_context = view_context
    end

    def respond_to_missing?(...)
      true
    end

    def method_missing(method, *args, **kwargs, &block)
      component = COMPONENTS[method]

      raise "Component LycanUi::#{method.to_s.classify} not found" if component.nil?

      @view_context.render(component.new(*args, **kwargs), &block)
    end
  end

  def ui
    @ui ||= Builder.new(self)
  end
end
