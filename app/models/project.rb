class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Project'
  has_many :children, class_name: 'Project', foreign_key: 'parent_id', dependent: :destroy
  has_many :records

  validates_each :parent_id do |record, attr, value|
#     if value
#       record.errors.add(attr, 'Überverzeichnis gehört nicht zur gleichen Ausgabe!') if record.parent.parent
#     else
#       record.errors.add(attr, 'Überverzeichnis gehört nicht zur gleichen Ausgabe!') if record.children.any?
#     end
  end
end
