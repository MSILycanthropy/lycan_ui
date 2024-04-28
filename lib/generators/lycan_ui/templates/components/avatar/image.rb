# frozen_string_literal: true

class Avatar::Image < ApplicationComponent
  erb_template <<~ERB
    <%%= tag.img(**attributes) %>
  ERB

  def initialize(alt: nil, loading: nil, **attributes)
    attributes[:data] = data_attributes(
      {
        data: {
          avatar_target: "avatar",
        },
      },
      attributes,
    )
    attributes[:class] = class_names("object-cover col-start-1 row-start-1", attributes[:class])

    super(alt:, loading:, **attributes)
  end
end
