# frozen_string_literal: true

class Form
  attr_accessor :args, :kwargs, :view_context

  def initialize(*args, **kwargs)
    @args = args
    @kwargs = kwargs
  end

  def render_in(view_context, &block)
    view_context.form_with(*args, builder: Builder, **kwargs, &block)
  end

  class Builder < ActionView::Helpers::FormBuilder
    (field_helpers - [
      :label,
      :check_box,
      :radio_button,
      :fields_for,
      :fields,
      :hidden_field,
      :file_field,
      :color_field,
      :range_field,
      :text_area,
    ]).each do |selector|
      define_method(selector) do |method, options = {}|
        @template.render(Input.new(self.object_name, method, type: selector, **objectify_options(options)))
      end
    end

    def label(method, text = nil, options = {}, &block)
      @template.render(Label.new(self.object_name, method, text, **objectify_options(options), &block))
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = objectify_options(options)
      @template.render(Checkbox.new(self.object_name, method, options, checked_value, unchecked_value))
    end

    def text_area(method, options = {})
      @template.render(TextArea.new(self.object_name, method, **objectify_options(options)))
    end

    def radio_button(method, tag_value, options = {})
      @template.render(Radio.new(self.object_name, method, tag_value, **objectify_options(options)))
    end

    def file_field(method, options = {})
      self.multipart = true
      @template.render(Input.new(self.object_name, method, type: :file_field, **objectify_options(options)))
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      @template.render(Button.new(**options).with_content(value))
    end

    def button(value = nil, options = {}, &block)
      case value
      when Hash
        value, options = nil, value
      when Symbol
        value, options = nil, { name: field_name(value), id: field_id(value) }.merge!(options.to_h)
      end
      value ||= submit_default_value

      formmethod = options[:formmethod]
      if formmethod.present? && !/post|get/i.match?(formmethod) && !options.key?(:name) && !options.key?(:value)
        options.merge!(formmethod: :post, name: "_method", value: formmethod)
      end

      if block_given?
        @template.render(Button.new(**options, &block))
      else
        @template.render(Button.new(**options).with_content(value))
      end
    end
  end
end
