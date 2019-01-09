module Users
  class Create < ApplicationTransaction
    try :build, catch: ActiveRecord::UnknownAttributeError
    check :validate
    try :save, catch: ActiveRecord::RecordInvalid

    def build(params)
      User.new(params)
    end

    def validate(record)
      record.valid?
    end

    def save(record)
      record.save!
    end
  end
end
