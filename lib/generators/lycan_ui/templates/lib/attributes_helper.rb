# frozen_string_literal: true

module LycanUi
  module AttributesHelper
    def merge_data(*hashes)
      merge_attributes(*hashes, prefix: :data)
    end

    def merge_aria(*hashes)
      merge_attributes(*hashes, prefix: :aria)
    end

    private

    def merge_attributes(*hashes, prefix:)
      {}.tap do |merged|
        hashes.each do |hash|
          prefixed_hash = hash.delete(prefix) || hash.delete(prefix.to_s) || {}

          prefixed_hash.each_pair do |key, value|
            merged[key.to_sym] = if merged.key?(key.to_sym)
              merge_attribute(merged[key.to_sym], value)
            else
              value
            end
          end

          hash.delete_if do |key, value|
            string_key = key.to_s.dasherize
            starts_with = string_key.starts_with?("#{prefix}-")

            if starts_with
              bare_key = string_key.sub("#{prefix}-", "").to_sym
              merged[bare_key] = if merged.key?(bare_key)
                merge_attribute(merged[bare_key], value)
              else
                value
              end
            end

            starts_with
          end
        end
      end.with_indifferent_access
    end

    def merge_attribute(existing, incoming)
      case existing
      when Hash
        existing.merge(incoming)
      when Array
        existing + Array(incoming)
      when String, Symbol
        [ existing, incoming ].compact.join(" ")
      else
        incoming
      end
    end
  end
end
