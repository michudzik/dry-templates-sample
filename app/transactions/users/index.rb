module Users
  class Index < ApplicationTransaction
    try :fetch_all_users, catch: ActiveRecord::ActiveRecordError

    private

    def fetch_all_users
      User.all
    end
  end
end
