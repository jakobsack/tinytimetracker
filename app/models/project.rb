class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Project'
  has_many :children, class_name: 'Project', foreign_key: 'parent_id', dependent: :destroy
  has_many :records, dependent: :destroy

  attr_accessor :depth, :is_first_child, :is_last_child

  validates :name, presence: true, allow_blank: false
  validates_each :parent_id do |record, attr, value|
    used_ids = []
    current = record
    while current
      if used_ids.include?(current.id)
        record.errors.add(attr, 'It\'s a project tree, not a project cycle!')
        break
      end
      used_ids << current.id
      current = current.parent
    end
  end

  def to_label
    "--" * (depth || 0) + name
  end

  def self.tree projects
    # create the tree
    recursive_tree_worker projects.sort { |a, b| a.name <=> b.name}, 0
  end

  def self.recursive_tree_worker projects, my_depth, my_current_id = nil
    temp_list = []

    # crawl through all projects
    projects.each do |project|
      if project.parent_id == my_current_id
        project.depth = my_depth
        temp_list << project
        temp_list.concat recursive_tree_worker( projects, my_depth + 1, project.id )
      end
    end

    # Add first child and last_child
    unless temp_list.length == 0
      temp_list.first.is_first_child = true
      temp_list.reverse.each do |project|
        if project.depth == my_depth
          project.is_last_child = true
          break
        end
      end
    end

    # return list
    temp_list
  end

  def <=> other
    name <=> other.name
  end
end

__END__
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
