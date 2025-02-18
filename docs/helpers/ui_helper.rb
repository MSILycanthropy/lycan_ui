# frozen_string_literal: true

module UiHelper
  class Builder
    def initialize(context)
      @context = context
    end

    def reset_partial
      @current_partial = nil
    end

    def respond_to_missing?(...)
      true
    end

    def method_missing(method, *args, **, &block)
      previous_partial = @current_partial
      @current_partial = if previous_partial.nil?
        method.to_s
      else
        "#{previous_partial}/#{method}"
      end

      content = if block_given?
        @context.render("views/#{@current_partial}", args:, **) do |*args|
          previous_partial.nil? ? yield(self, *args) : yield(*args)
        end
      else
        @context.render("views/#{@current_partial}", args:, **)
      end

      @current_partial = previous_partial

      content
    end
  end

  def ui
    @ui ||= Builder.new(self)
    @ui.reset_partial
    @ui
  end

  def use_id
    @counter ||= 0
    @counter += 1

    "_l#{@counter}_"
  end
end
