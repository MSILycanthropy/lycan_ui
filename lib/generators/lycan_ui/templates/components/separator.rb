# frozen_string_literal: true

class Separator < LycanUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) %>
  ERB

  ORIENTATIONS = [ :horizontal, :vertical ].freeze

  def initialize(orientation: :horizontal, **attributes)
    orientation = orientation.to_sym
    validates_argument_in(orientation, ORIENTATIONS)

    attributes[:role] = :none
    attributes[:data] = data_attributes(
      { orientation: },
      attributes,
    )
    attributes[:aria] = aria_attributes(
      { hidden: true },
      attributes,
    )

    orientation_classes = if orientation == :horizontal
      "h-[1px] w-full my-4"
    else
      "w-[1px] h-full mx-4"
    end

    attributes[:classes] = class_names(
      "shrink-0 bg-black",
      orientation_classes,
      attributes[:classes],
    )

    super(**attributes)
  end
end
