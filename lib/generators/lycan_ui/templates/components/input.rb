# frozen_string_literal: true

class Input < ApplicationComponent
  attr_accessor :object_name, :method, :type

  def initialize(object_name, method, type: :text_field, **attributes)
    @object_name = object_name
    @method = method
    @type = type.to_s

    attributes[:class] = class_names(
      "flex h-10 w-full rounded-md border border-black px-3 py-2 text-sm " \
        "file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "disabled:cursor-not-allowed disabled:opacity-50",
      attributes[:class],
    )

    super(**attributes)
  end

  def call
    helpers.send(fieldified_type, object_name, method, attributes)
  end

  private

  def fieldified_type
    return type if type.ends_with?("_field")

    "#{type}_field"
  end
end
