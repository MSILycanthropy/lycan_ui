# frozen_string_literal: true

module LycanUi
  module FormHelper
    class FormBuilder < ActionView::Helpers::FormBuilder
      def checkbox(method, options = {}, checked_value = "1", unchecked_value = "0")
        @template.render(
          "ui/checkbox",
          args: [ @object_name, method, objectify_options(options), checked_value, unchecked_value ],
        )
      end

      def switch(method, options = {}, checked_value = "1", unchecked_value = "0")
        @template.render(
          "ui/checkbox",
          args: [ @object_name, method, objectify_options(options), checked_value, unchecked_value ],
        )
      end

      def radio_button(method, tag_value, options = {})
        @template.render("ui/radio", args: [ @object_name, method, tag_value, objectify_options(options) ])
      end
    end

    def lycan_ui_form_with(*, **, &)
      form_with(*, builder: FormBuilder, **, &)
    end
  end
end
