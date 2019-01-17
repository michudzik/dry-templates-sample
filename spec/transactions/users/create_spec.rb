require 'rails_helper'

RSpec.configure do |config|
  include Dry::Monads::Result::Mixin
end

RSpec.describe Users::Create do
  describe '#call' do
    subject { described_class.new.call(params) }

    context 'when transaction is successful' do
      let(:params) { { username: 'test_username', email: 'test@email.com' } }

      it 'creates new user' do
        expect{ subject }.to change{ User.count }.by 1
      end
    end

    context 'when unexpected arguments are passed' do
      let(:params) { { username: 'test_username', email: 'test@email.com', invalid_param: 'invalid param' } }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::UnknownAttrbiuteError
          end
        end
      end
    end

    context 'when arguments are not valid' do
      let(:params) { { username: 'test_username', email: 'test@email.com' } }
      before { allow_any_instance_of(User).to receive(:valid?).and_return false }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns a user' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::UnknownAttrbiuteError
          end
        end
      end

      it 'returns an unpersisted user' do
        subject do |r|
          r.failure do |m|
            expect(m.value!.persited?).to eq false
          end
        end
      end
    end

    context 'when something happens during saving' do
      let(:params) { { username: 'test_username', email: 'test@email.com' } }
      before { allow_any_instance_of(User).to receive(:save!).and_raise(ActiveRecord::RecordInvalid) }

      it 'is a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::RecordInvalid
          end
        end
      end
    end
  end
end
