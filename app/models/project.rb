class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Project'
  has_many :children, class_name: 'Project', foreign_key: 'parent_id', dependent: :destroy
  has_many :records

  validates_each :parent_id do |record, attr, value|
    record.errors.add(attr, 'Das Projekt  kann kein Unterprojekt seiner selbst sein!') if value == id
  end

  def <=> other
    if parent_id && other.parent_id && parent_id == other.parent_id
      name <=> other.name
    elsif parent_id && other.parent_id
      parent <=> other.parent
    elsif parent_id == other.id
      1
    elsif parent_id
      parent <=> other
    elsif other.parent_id
      self <=> other.parent
    else
      name <=> other.name
    end
  end
end
