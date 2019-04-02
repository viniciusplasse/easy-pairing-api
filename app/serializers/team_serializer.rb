class TeamSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name

  has_many :members
end
