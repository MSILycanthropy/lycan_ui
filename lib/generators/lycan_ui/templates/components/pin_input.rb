# frozen_string_literal: true

class PinInput < LycanUiComponent
  attr_accessor :object_name, :method, :type, :length, :options

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%% length.times do |i| %>
        <%%= pin_input(i) %>
      <%% end %>
      <%%= hidden_field(object_name, method, options) %>
    <%% end %>
  ERB

  def initialize(object_name, method, options = {}, type: :text, length: 5, **attributes)
    @object_name = object_name
    @method = method

    options[:data] = data_attributes({ data: { pin_input_target: "hiddenField" } }, options)
    @autofocus = options.delete(:autofocus)

    @options = options
    @type = type.to_s.split("_").first
    @length = length

    attributes[:class] = class_names(
      "flex items-center gap-2",
      attributes[:class],
    )

    attributes[:data] = data_attributes(
      { data: { controller: "pin-input", pin_input_length_value: length } },
      attributes,
    )

    super(**attributes)
  end

  private

  INPUT_ACTIONS = [
    "pin-input#set",
    "paste->pin-input#fillAll:self",
    "keydown->pin-input#prevFieldBackspace:self",
    "keydown->pin-input#delete:self",
    "keydown.tab->pin-input#nextField:self",
    "keydown.tab+shift->pin-input#prevField:self",
    "keydown.right->pin-input#nextField:self",
    "keydown.left->pin-input#prevField:self",
  ].join(" ").freeze
  def pin_input(index)
    autofocus = @autofocus && index.zero?

    helpers.tag.input(
      type: type,
      class: "border-2 border-gray-400 transition-colors rounded-xl text-center " \
        "text-lg size-12 aspect-square focus:outline-none focus:border-black",
      autofocus: autofocus,
      data: { action: INPUT_ACTIONS, pin_input_target: :field },
    )
  end
end
