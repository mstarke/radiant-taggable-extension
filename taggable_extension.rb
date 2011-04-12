class TaggableExtension < Radiant::Extension
  version "1.2.5"
  description "General purpose tagging and retrieval extension: more versatile but less focused than the tags extension"
  url "http://github.com/spanner/radiant-taggable-extension"
    
  def activate
    require 'natcmp'                                                    # a natural sort algorithm. possibly not that efficient.
    ActiveRecord::Base.send :include, TaggableModel                     # provide is_taggable for everything but don't call it for anything
    Page.send :is_taggable                                              # make pages taggable 
    Page.send :include, TaggablePage                                    # then fake the keywords column and add some inheritance
    Page.send :include, TaggableTags                                    # and the basic radius tags for showing page tags and tag pages
    Admin::PagesController.send :include, TaggableAdminPageController   # tweak the admin interface to make page tags more prominent
    UserActionObserver.instance.send :add_observer!, Tag                # tags get creator-stamped

    unless defined? admin.tag
      Radiant::AdminUI.send :include, TaggableAdminUI
      admin.tag = Radiant::AdminUI.load_default_tag_regions
    end

    tab("Content") do
      add_item("Tags", "/admin/tags")
    end
  end
end
