class Report < ApplicationRecord

  belongs_to :user
  belongs_to :reportable, polymorphic: true

  enum reason: {racism: 1,
                violence: 2,
                pornography: 3,
                religion: 4,
                discrimination: 5}, _suffix: :reason              
end
