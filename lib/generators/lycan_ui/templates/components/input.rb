# frozen_string_literal: true

class Input < LycanUiComponent
  attr_accessor :form, :name, :type

  def initialize(form:, name:, type: :text, **attributes)
    @form = form
    @name = name
    @type = type

    attributes[:class] = merge_classes(
      "flex h-10 w-full rounded-md border border-black px-3 py-2 text-sm " \
        "file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "disabled:cursor-not-allowed disabled:opacity-50",
      attributes[:class],
    )

    super(**attributes)
  end

  def call
    form.send("#{type}_field", name, **attributes)
  end
end
