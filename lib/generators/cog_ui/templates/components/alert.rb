# frozen_string_literal: true

class Alert < CogUiComponent
  renders_one :icon
  renders_one :title, "Title"
  renders_one :description, "Description"

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= icon %>
      <%%= title %>
      <%%= description %>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = merge_classes(
      "relative w-full rounded-lg border px-4 py-3 text-sm " \
        "[&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:fill-current [&>svg]:text-white [&>svg~*]:pl-7 " \
        "bg-black text-white",
      attributes[:class])
    attributes[:role] = "alert"

    super(**attributes)
  end
end
