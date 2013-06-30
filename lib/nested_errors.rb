require 'rubygems'
require 'active_record'

module Netphase
  module NestedErrors
    VERSION = '1.0.0'

      def nested_error_messages_for(object)
        object = instance_variable_get("@#{object}") if ([Symbol, String].member? object.class)
          unless object.nil? || object.errors.count.zero?      
            error_messages = object.errors.to_a.uniq.map do |key, value|
              if key == "base"
                content_tag(:li, value)
              else
                object2 = object.send(key) rescue key
                if object2.is_a?(ActiveRecord::Base)
                  content_tag(:li, nested_error_messages_for(object2))
                elsif value.match(/^\^/)
                  content_tag(:li, value[1..value.length])
                elsif object2.is_a?(Array) 
                  object2.collect {|obj| content_tag(:li, nested_error_messages_for(obj)) }
                else
                  content_tag(:li, "#{key.underscore.split('_').join(' ').humanize} #{value}")
                end
              end
            end
            content_tag(:div, 
              content_tag(:div, "#{object.class.to_s.underscore.humanize} has errors", :class => 'error_field') +
              content_tag(:ul, error_messages),
              :class => 'error_block')
          else
            ''
          end
      end

  end
end