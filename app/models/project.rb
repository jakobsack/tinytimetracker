class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Project'
  has_many :children, class_name: 'Project', foreign_key: 'parent_id', dependent: :destroy
  has_many :records
end
