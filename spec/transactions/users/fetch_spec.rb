require 'rails_helper'

RSpec.configure do |config|
  include Dry::Monads::Result::Mixin
end

RSpec.describe Users::Fetch do
  describe '#call' do
    subject { described_class.new.call(params[:id]) }

    context 'when transaction is successful' do
      let(:user) { User.create(username: 'username', email: 'test@email.com')}
      let(:params) { { id: user.id } }

      it 'is a Success' do
        expect(subject).to be_a Success
      end

      it 'returns wrapped user' do
        subject do |r|
          r.success do |m|
            expect(m).to eq user
          end
        end
      end
    end

    context 'when user does not exist' do
      let(:params) { { id: -5 } }

      it 'returs a failure' do
        expect(subject).to be_a Failure
      end

      it 'returns wrapped exception' do
        subject do |r|
          r.failure do |m|
            expect(m.value!).to be_a ActiveRecord::RecordNotFound
          end
        end
      end
    end
  end
end
