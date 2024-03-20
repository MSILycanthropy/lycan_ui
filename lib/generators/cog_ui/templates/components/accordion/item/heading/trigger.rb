class <%= class_name %>::Item::Heading::Trigger < CogUiComponent
  erb_template <<~ERB
    <%%= content %>
  ERB

  def initialize(controls:, **attributes)
    attributes[:tag] = :button
    attributes[:type] = :button

    disabled = attributes[:disabled]

    attributes[:data] =
      merge_data(
        attributes,
        data: { <%= file_name %>__item_target: :trigger, action: "click-><%= file_name.to_s.dasherize %>--item#toggle" },
      )
    attributes[:aria] = merge_aria(attributes, aria: { expanded: false, controls:, disabled: })

    super(**attributes)
  end
end
