# frozen_string_literal: true

class Importmap::Map
  private

  def absolute_root_of(path)
    (pathname = Pathname.new(path)).absolute? ? pathname : Pathname.new(Dir.pwd).join(path)
  end
end

# Default layout for Sitepress pages
Sitepress.configure do |config|
  ## Change the root_path of the Sitepress site, or set to a different
  ## Sitepress instance.
  config.site = Sitepress::Site.new(root_path: ".")

  config.site.manipulate do |root|
    docs = root.dig('docs')

    sorted = docs.children.sort_by(&:name)

    sorted.each do |thing|
      thing.remove
      thing.parent = docs
    end
  end

  ActionController::Base.prepend_view_path(Pathname.new(Dir.pwd).join('../lib/generators/lycan_ui/templates'))
  Rails.application.config.assets.paths << (Pathname.new(Dir.pwd).join('../lib/generators/lycan_ui/templates/javascript'))
  Rails.application.config.assets.paths << (Pathname.new(Dir.pwd).join('vendor/javascript'))
  Rails.application.config.importmap.paths << Pathname.new(Dir.pwd).join('config', 'importmap.rb')
  Rails.application.config.importmap.cache_sweepers << Pathname.new(Dir.pwd).join('javascripts')
end
