module Users
  class Destroy < ApplicationTransaction
    try :find, catch: ActiveRecord::RecordNotFound
    try :delete, catch: ActiveRecord::RecordNotDestroyed

    def find(id)
      User.find(id)
    end

    def delete(record)
      record.destroy!
    end
  end
end
