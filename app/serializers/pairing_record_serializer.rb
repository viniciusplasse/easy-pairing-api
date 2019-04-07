class PairingRecordSerializer < ActiveModel::Serializer
  attributes :id
  attributes :date

  has_many :members

  def members
    serialized_distinct_members
  end

  private

  def distinct_members
    object.members.uniq
  end

  def serialized_distinct_members
    distinct_members.map do |member|
      MemberSerializer.new(member)
    end
  end
end
