module Nakajima
  module BetterEditInPlace
    def edit_in_place(resource, field, options={})
      # Get record to be edited. If resource is an array, pull it out.
      record = resource.is_a?(Array) ? resource.last : resource

      options[:id]  ||= "#{dom_id(record)}_#{field}"
      options[:tag] ||= :span
      options[:url] ||= url_for(resource)
      options[:rel] ||= options.delete(:url)
      options[:edit_blank]   ||= true
      options[:empty_message] ||= "[#{field.to_s.humanize}]"
      
      options.delete(:url) # Just in case it wasn't cleared already

      classes = options[:class].split(' ') rescue []
      classes << 'editable' if classes.empty?
      options[:class] = classes.uniq.join(' ')
      
      
      if record.send(field).blank? && options.delete(:edit_blank)
        options[:class] << ' novalue'
        data = options.delete(:empty_message)
      else
        data = record.send(field)
      end
      # Cleanup options hash
      options.delete(:edit_blank)
      options.delete(:empty_message)
      
      content_tag(options.delete(:tag), data, options)
    end
  end  
end

ActionView::Base.send :include, Nakajima::BetterEditInPlace
