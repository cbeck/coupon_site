class IssueStatus < ActiveRecord::Base
  has_many :contacts, :dependent => :nullify
  
  acts_as_enumerated
end
