class <%= class_name %>::Item < CogUiComponent
  attr_accessor :disabled, :opened_class, :closed_class, :controls, :labelledby

  renders_one :heading, ->(**attributes) {
    Heading.new(disabled:, controls:, labelledby:, **attributes)
  }
  renders_one :body, ->(**attributes) {
    attributes[:id] = controls
    attributes[:class] = merge_classes(attributes[:class], closed_class)
    attributes[:aria] = merge_aria(attributes, { aria: { labelledby: } })

    Body.new(**attributes)
  }

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= heading %>
      <%%= body %>
    <%% end %>
  ERB

  def initialize(disabled: false, opened_class: nil, closed_class: nil, **attributes)
    @disabled = disabled
    @opened_class = opened_class
    @closed_class = closed_class
    @controls = generate_id
    @labelledby = generate_id(base: "<%= file_name.to_s.dasherize %>-trigger")

    attributes[:data] = merge_data(data_attributes, attributes)

    super(**attributes)
  end

  private

  def data_attributes
    data = {
      <%= file_name %>__item_state_value: "opened",
      controller: "<%= file_name.to_s.dasherize %>--item",
    }

    data[:<%= file_name %>__item_opened_class] = opened_class if opened_class
    data[:<%= file_name %>__item_closed_class] = closed_class if closed_class

    { data: }
  end
end
