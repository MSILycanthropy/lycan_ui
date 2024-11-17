# frozen_string_literal: true

module LycanUiHelper
  class LycanUiBuilder
    def initialize(context, prefix: nil)
      @context = context
      @prefix = prefix
      @locals = {}
    end

    def with_prefix(prefix)
      @prefix = prefix

      yield

      @prefix = nil
    end

    def with_locals(**kwargs)
      @locals = kwargs

      yield

      @locals = {}
    end

    def method_missing(method, *args, **kwargs, &block)
      kwargs[:classes] = kwargs.delete(:class)
      kwargs[:variant] ||= nil

      opts = kwargs.except(:classes, :variant)

      template_name = if @prefix.present?
        "#{@prefix}/#{method}"
      else
        method
      end

      if block_given?
        @context.render("ui/#{template_name}", *args, opts:, **@locals, **kwargs, &block)
      else
        @context.render("ui/#{template_name}", *args, opts:, **@locals, **kwargs)
      end
    end
  end

  def ui
    @ui ||= LycanUiBuilder.new(self)
  end

  def use_id
    @counter ||= 0
    @counter += 1

    ":l#{@counter}:"
  end

  def select_variant(options, variant)
    variant = variant&.to_sym
    return options.first.last if variant.nil?

    options[variant]
  end

  def class_names(*args)
    return if args.all?(&:nil?)

    args.flat_map do |classes|
      classes = classes.split(" ") if classes.is_a?(String)

      classes
    end.uniq.compact.join(" ")
  end
end
