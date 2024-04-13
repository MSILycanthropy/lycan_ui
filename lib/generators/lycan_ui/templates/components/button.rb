# frozen_string_literal: true

class Button < LycanUiComponent
  attr_accessor :form, :name, :text

  erb_template <<~ERB
    <%%= tag.button(**attributes) do %>
      <%%= content %>
    <%% end %>
  ERB

  VARIANTS = [ :primary, :secondary, :danger, :outline, :ghost, :link ].freeze

  def initialize(variant: :primary, **attributes)
    variant = variant.to_sym
    validates_argument_in(variant, VARIANTS)

    variant_classes = case variant
    when :primary
      "bg-black text-white hover:bg-black/90"
    when :secondary
      "bg-stone-600 text-white hover:bg-stone-600/80 h-10 px-4 py-2"
    when :danger
      "bg-red-800 text-white hover:bg-red-800/90 h-10 px-4 py-2"
    when :outline
      "border border-black hover:bg-stone-600 hover:text-white h-10 px-4 py-2"
    when :ghost
      "hover:bg-stone-600 hover:text-white h-10 px-4 py-2"
    when :link
      "text-black underline-offset-4 hover:underline h-10 px-4 py-2"
    end

    animation_classes = unless variant == :link
      "motion-safe:transition-transform motion-safe:active:scale-95 ease-in-out"
    end

    attributes[:class] = merge_classes(
      "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium " \
        "transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-black " \
        "focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2 ",
      animation_classes,
      variant_classes,
      attributes[:class],
    )

    super(**attributes)
  end
end
