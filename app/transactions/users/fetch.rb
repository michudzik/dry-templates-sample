module Users
  class Fetch < ApplicationTransaction
    try :find, catch: ActiveRecord::RecordNotFound

    private

    def find(id)
      User.find(id)
    end
  end
end
