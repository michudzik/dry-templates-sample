require 'rails_helper'

RSpec.configure do |config|
  include Dry::Monads::Result::Mixin
end

RSpec.describe Users::Update do
  describe '#call' do
    subject { described_class.new.call(params) }

    context 'when transaction is successful' do
      let(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: user.id, username: 'updated_username' } }

      it 'changes user\'s username' do
        subject
        expect(user.reload.username).to eq 'updated_username'
      end
    end

    context 'when user does not exist' do
      let(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: -5, username: 'updated_username' } }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(subject.value!).to be_a ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context 'when something happens during saving' do
      let(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: user.id, username: 'updated_username' } }
      before { allow_any_instance_of(User).to receive(:save!).and_raise ActiveRecord::RecordInvalid }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(subject.value!).to be_a ActiveRecord::RecordInvalid
          end
        end
      end
    end
  end
end
