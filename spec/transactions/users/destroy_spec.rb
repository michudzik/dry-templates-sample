require 'rails_helper'

RSpec.configure do |config|
  include Dry::Monads::Result::Mixin
end

RSpec.describe Users::Destroy do
  describe '#call' do
    subject { described_class.new.call(params[:id]) }

    context 'when transaction is successful' do
      let!(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: user.id } }

      it 'destroys a user' do
        expect{ subject }.to change{ User.count }.by -1
      end
    end

    context 'when user is not found' do
      let(:params) { { id: -5 } }

      it 'returns a Failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::RecordNotFound
          end
        end
      end

      it 'does not change user count' do
        expect{ subject }.not_to change{ User.count }
      end
    end

    context 'when something happens during saving' do
      let!(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: user.id } }
      before { allow_any_instance_of(User).to receive(:destroy!).and_raise ActiveRecord::RecordNotDestroyed }

      it 'returns a Failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::RecordNotDestroyed
          end
        end
      end

      it 'does not change user count' do
        expect{ subject }.not_to change{ User.count }
      end
    end
  end
end
