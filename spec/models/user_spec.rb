require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it 'has proper attributes' do
      expect(subject.attributes).to include 'username', 'email'
    end
  end
end
