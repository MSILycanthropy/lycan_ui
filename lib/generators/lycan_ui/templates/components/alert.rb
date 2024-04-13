# frozen_string_literal: true

class Alert < LycanUiComponent
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

  VARIANTS = [ :default, :danger ]

  def initialize(variant: :default, **attributes)
    variant = variant.to_sym

    variant_classes = if variant == :danger
      "text-red-800 border-red-800 [&>svg]:text-red-800"
    else
      "text-white [&>svg]:text-white"
    end

    attributes[:class] = merge_classes(
      "relative w-full rounded-lg border px-4 py-3 text-sm " \
        "[&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:fill-current [&>svg~*]:pl-7",
      variant_classes,
      attributes[:class],
    )

    attributes[:role] = "alert"

    super(**attributes)
  end
end
