# frozen_string_literal: true

class Badge < CogUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  VARIANTS = [ :default, :danger, :outline ].freeze

  def initialize(variant: :default, **attributes)
    validates_argument_in(variant, VARIANTS)

    variant_classes = case variant
    when :danger
      "text-white bg-red-800 focus:ring-red-800"
    when :outline
      "bg-transparent border-black"
    else
      "text-white bg-black focus:ring-black border-transparent"
    end

    attributes[:class] = merge_classes(
      "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors " \
        "focus:outline-none focus:ring-2 focus:ring-offset-2",
      variant_classes,
      attributes[:class])

    super(**attributes)
  end
end
