class Issue < ApplicationRecord
 validates_presence_of :title, :created_by, :assigned_to
end
