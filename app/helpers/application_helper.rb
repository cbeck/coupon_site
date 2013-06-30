require 'nested_errors'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Netphase::NestedErrors
  
   # moved from business because intend to use for images in several locations
   def add_item_link(tag_id, partial, object, label=nil, show_div=nil)
     link_to_function "add #{label || partial}", :class => 'add_item' do |page|
  			page.insert_html :bottom, tag_id, :partial => partial, :object => object
  			page[show_div].show() unless show_div.nil?
  	 end
   end

   def remove_item_link(name, object, action, id_to_remove=nil)
     removal = (id_to_remove.nil?) ? "up().remove()" : "$('#{id_to_remove}').remove()"
     if object.new_record?
       link_to_function(image_tag('bin.png', :title => "remove #{name}"), "#{removal}")
     else
       link_to_remote(image_tag('bin.png', :title => "remove #{name}"), 
  				:url => { :action => action, :id => object },
  				:confirm => "Delete this #{name}: #{object.to_s}?",
  				:success => "#{removal}",
  				:html => {:class => "trash_can"})
  	 end
   end
  
  # A helper to show flash messages as an ajax messenger be it as a notice or error (if warning). Options include the keys to test
  # the id of the messages client, and whether to textilize the data.
  def show_ajax_flash_messages(options={}, page=nil)
     options = { :keys => [:warning, :notice, :message],
                  :id => 'messages',
                  :textilize => false,
                  :wrap_js => true}.merge(options)
      out = []
      message = nil
      options[:keys].each do |key|
        next unless flash[key]
        [flash[key]].flatten.compact.each do |msg|
          text = (options[:textilize] ? textilize(msg) : msg)
          message = text
        end
        type = "notice"
        type = "error" if key == :warning
        if !message.nil?
          if page.nil?
            out << "<script type=\"text/javascript\"> " if options[:wrap_js]
            out << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
            out << "</script>" if options[:wrap_js]
          else
            page << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
          end
        end
        flash.discard(key)
      end
      if page.nil?
        return nil if out.empty? 
        return out
      end
  end
  
  def render_boolean_image(val)
    output = ""
    if val 
      output += image_tag('tick.png')
    else
      output += image_tag('cancel.png')
    end
    output
  end
  
  def render_header
    output = '<div id="details_container"><div id="text_container"><div id="text_container_top"><div id="text_container_inner">'    
  end
  
  def render_footer
    output = '</div></div></div><div class="clear_fix">&nbsp;</div></div>'
  end
  
  def render_title
    output = "<h3>#{@title}</h3>"
  end
  
  def is_ie?
    request.env['HTTP_USER_AGENT'].index('MSIE')
  end
  
  def render_active_status(object)
    output = ""
    if object.active? 
      output += image_tag('tick.png')
    else
      output += image_tag('cancel.png')
    end
    output
  end
  
  def google_analytics(analytics_code = "UA-11624655-1")
    urchin = <<-EOS
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("#{analytics_code}");
      pageTracker._trackPageview();
      } catch(err) {}</script>
    EOS
    urchin if ENV['RAILS_ENV'] == 'production'
  end
  
  
  
end
