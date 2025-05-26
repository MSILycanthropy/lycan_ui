# frozen_string_literal: true

module FormHelper
  class FormBuilder < ActionView::Helpers::FormBuilder
    [
      :date,
      :datetime,
      :email,
      :month,
      :number,
      :password,
      :search,
      :telephone,
      :text,
      :url,
      :week,
    ].each do |type|
      define_method("#{type}_field") do |method, options = {}|
        options = objectify_options(options)
        options[:type] = type

        @template.ui.input(@object_name, method, options)
      end
    end

    def button(value = nil, options = {}, &block)
      case value
      when Hash
        value, options = nil, value
      when Symbol
        value, options = nil, { name: field_name(value), id: field_id(value) }.merge!(options.to_h)
      end
      value ||= submit_default_value

      if block_given?
        value = @template.capture { yield(value) }
      end

      formmethod = options[:formmethod]
      if formmethod.present? && !/post|get/i.match?(formmethod) && !options.key?(:name) && !options.key?(:value)
        options.merge!(formmethod: :post, name: "_method", value: formmethod)
      end

      options[:type] ||= :submit

      @template.ui.button(value, **options)
    end

    def checkbox(method, options = {}, checked_value = "1", unchecked_value = "0")
      @template.ui.checkbox(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    end

    def file_field(method, options = {})
      self.multipart = true
      options = objectify_options(options)
      options[:type] = :file

      @template.ui.input(@object_name, method, options)
    end

    def label(method, text = nil, options = {}, &block)
      @template.ui.label(@object_name, method, text, objectify_options(options), &block)
    end

    def radio_button(method, tag_value, options = {})
      @template.ui.radio(@object_name, method, tag_value, objectify_options(options))
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      button(value, options)
    end

    def switch(method, options = {}, checked_value = "1", unchecked_value = "0")
      @template.ui.switch(@object_name, method, objectify_options(options), checked_value, unchecked_value)
    end

    def textarea(method, options = {})
      @template.ui.textarea(@object_name, method, objectify_options(options))
    end

    def select(method, choices = nil, options = {}, html_options = {})
      @template.ui.select(@object_name, method, choices, options, html_options)
    end
  end

  def lycan_ui_form_with(*, **, &)
    form_with(*, builder: FormBuilder, **, &)
  end
end
