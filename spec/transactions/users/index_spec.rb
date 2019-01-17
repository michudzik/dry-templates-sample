require 'rails_helper'

RSpec.configure do |config|
  include Dry::Monads::Result::Mixin
end

RSpec.describe Users::Index do
  describe '#call' do
    subject { described_class.new.call }

    context 'when transaction is successful' do
      let(:user_1) { User.create(username: 'username', email: 'test@email.com') }
      let(:user_2) { User.create(username: 'username_1', email: 'test_1@email.com') }
      let(:users) { [user_1, user_2] }

      it 'is successful' do
        expect(subject).to be_a Success
      end

      it 'returns collection of users' do
        subject do |r|
          r.success do |m|
            expect(m).to eq users
          end
        end
      end
    end

    context 'when database connection is lost' do
      before { allow(User).to receive(:all).and_raise ActiveRecord::ActiveRecordError }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::ActiveRecordError
          end
        end
      end
    end
  end
end
