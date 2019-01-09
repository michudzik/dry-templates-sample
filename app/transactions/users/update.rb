module Users
  class Update < ApplicationTransaction
    try :find, catch: ActiveRecord::RecordNotFound
    map :update_attributes
    try :save, catch: ActiveRecord::RecordInvalid

    def find(params)
      { record: User.find(params[:id]), attributes: params.except(:id) }
    end

    def update_attributes(params)
      params[:record].assign_attributes(params[:attributes])
    end

    def save(record)
      record.save!
    end
  end
end
