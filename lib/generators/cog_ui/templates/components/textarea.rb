# frozen_string_literal: true

class Textarea < CogUiComponent
  attr_accessor :form, :name, :type

  erb_template <<~ERB
    <%%= form.text_area(name, **attributes) %>
  ERB

  def initialize(form:, name:, type: :text, **attributes)
    @form = form
    @name = name
    @type = type

    attributes[:class] = merge_classes(
      "flex min-h-[5rem] w-full rounded-md border border-black px-3 py-2 text-sm " \
        "file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black focus-visible:ring-offset-2 " \
        "disabled:cursor-not-allowed disabled:opacity-50",
      attributes[:class],
    )

    super(**attributes)
  end
end
