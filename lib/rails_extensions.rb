module ActiveRecord
  class Base
      def self.count_since(time_ago)
        count(:conditions => ['created_at > ?', time_ago])
      end
  end
end

include ActsAsTaggableOn

module ActsAsTaggableOn
  class Tag < ::ActiveRecord::Base
  
    define_index do
      indexes :name
      has "UPPER(name)", :as => :uname, :type => :string, :sortable => true
    end
  
    def to_param
      "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}" unless name.blank?
    end
  end
end

class Float
  def to_radians
    ( self / 360.0 ) * Math::PI * 2
  end
end
