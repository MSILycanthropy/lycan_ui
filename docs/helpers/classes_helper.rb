# frozen_string_literal: true

module ClassesHelper
  def select_variant(options, variant)
    variant = variant&.to_sym
    return options.first.last if variant.nil?

    options[variant]
  end

  def class_names(*args)
    return if args.all?(&:nil?)

    classes = args.flat_map do |classes|
      classes = classes.split(" ") if classes.is_a?(String)

      classes
    end

    @merger ||= TailwindMerge::Merger.new
    @merger.merge(classes)
  end
end
