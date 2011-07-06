class Todoitem
  include Mongoid::Document
  field :entry, :type => String, :label => 'Entry'
  field :made_at, :type => Time, :label => 'Made at'
  field :completed, :type => Boolean, :label => 'Task Completed'
#  field :count, :type => Integer

  validates :entry, :presence => true
#  validates :count, :presence => true, :length => {:minimum => 3}
end
