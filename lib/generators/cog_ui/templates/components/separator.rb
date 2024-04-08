# frozen_string_literal: true

class Separator < CogUiComponent
  erb_template <<~ERB
    <%%= tag.div(**attributes) %>
  ERB

  ORIENTATIONS = [ :horizontal, :vertical ].freeze

  def initialize(orientation: :horizontal, **attributes)
    orientation = orientation.to_sym
    validates_argument_in(orientation, ORIENTATIONS)

    attributes[:role] = :none
    attributes[:data] = merge_data(
      { orientation: },
      attributes,
    )
    attributes[:aria] = merge_aria(
      { hidden: true },
      attributes,
    )

    orientation_classes = if orientation == :horizontal
      "h-[1px] w-full my-4"
    else
      "w-[1px] h-full mx-4"
    end

    attributes[:classes] = merge_classes(
      "shrink-0 bg-black",
      orientation_classes,
      attributes[:classes],
    )

    super(**attributes)
  end
end
