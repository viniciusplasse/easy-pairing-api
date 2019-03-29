class Pair < ApplicationRecord
  has_one :member, :class_name => 'Member', :foreign_key => 'member_id'
  has_one :other_member, :class_name => 'Member', :foreign_key => 'other_member_id'
end
