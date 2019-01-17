require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create(username: 'test_username', email: 'test_email@test.com') }

  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end

    it 'renders correct template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'is successful' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'renders correct template' do
      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end

    it 'renders correct template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'is successful' do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'renders correct template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'when valid params are passed' do
      it 'redirects to users index' do
        post :create, params: { user: { username: 'test_username', email: 'test_email' } }
        expect(response).to redirect_to users_path
      end

      it 'redirects with a notice' do
        post :create, params: { user: { username: 'test_username', email: 'test_email' } }
        expect(flash[:notice]).to be_present
      end
    end

    context 'when validation fails' do
      it 'renders new template' do
        post :create, params: { user: { username: '', email: 'test_email' } }
        expect(response).to render_template :new
      end
    end

    context 'when database connection is dropped' do
      before { expect_any_instance_of(User).to receive(:save!).and_raise ActiveRecord::RecordInvalid }

      it 'redirects to users index' do
        post :create, params: { user: { username: 'test_username', email: 'test_email' } }
        expect(response).to redirect_to users_path
      end

      it 'redirects with an alert' do
        post :create, params: { user: { username: 'test_username', email: 'test_email' } }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    context 'when valid parms are passed' do
      it 'redirects to users index' do
        patch :update, params: { id: user.id, user: { username: user.username, email: user.email} }
        expect(response).to redirect_to users_path
      end

      it 'redirects with a notice' do
        patch :update, params: { id: user.id, user: { username: user.username, email: user.email} }
        expect(flash[:notice]).to be_present
      end
    end

    context 'when user is not found' do
      it 'redirects to users index' do
        patch :update, params: { id: -5, user: { username: user.username, email: user.email} }
        expect(response).to redirect_to users_path
      end

      it 'redirects with an alert' do
        patch :update, params: { id: -5, user: { username: user.username, email: user.email} }
        expect(flash[:alert]).to be_present
      end
    end

    context 'when validation fails' do
      it 'renders edit template' do
        patch :update, params: { id: user.id, user: { username: '', email: '' } }
        expect(response).to render_template :edit
      end
    end

    context 'when database connection is dropped' do
      before { allow_any_instance_of(User).to receive(:save!).and_raise ActiveRecord::RecordInvalid }

      it 'redirects to users index' do
        patch :update, params: { id: user.id, user: { username: user.username, email: user.email} }
        expect(response).to redirect_to users_path
      end

      it 'redirects with an alert' do
        patch :update, params: { id: user.id, user: { username: user.username, email: user.email} }
        expect(response).to redirect_to users_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user exists' do
      it 'redirects to users index' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to users_path
      end

      it 'redirects with a notice' do
        delete :destroy, params: { id: user.id }
        expect(flash[:notice]).to be_present
      end
    end

    context 'when user does not exist' do
      it 'redirects to users index' do
        delete :destroy, params: { id: -5 }
        expect(response).to redirect_to users_path
      end

      it 'redirects with an alert' do
        delete :destroy, params: { id: -5 }
        expect(flash[:alert]).to be_present
      end
    end

    context 'when database connection is dropped' do
      before { allow_any_instance_of(User).to receive(:destroy!).and_raise ActiveRecord::RecordNotDestroyed }

      it 'redirects to users index' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to users_path
      end

      it 'redirects with an alert' do
        delete :destroy, params: { id: user.id }
        expect(flash[:alert]).to be_present
      end
    end
  end
end
