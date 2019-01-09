require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    it 'renders correct template' do
      get :show, params: { id: 1 }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders correct template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'renders correct template' do
      get :edit, params: { id: 1 }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    it 'redirects to new' do
      post :create, params: { id: 1 }
      expect(response).to redirect_to new_user_path
    end

    it 'redirects with a notice' do
      post :create, params: { id: 1 }
      expect(flash[:notice]).to be_present
    end
  end

  describe 'PATCH #update' do
    it 'redirects to edit' do
      patch :update, params: { id: 1 }
      expect(response).to redirect_to edit_user_path
    end

    it 'redirects with a notice' do
      patch :update, params: { id: 1 }
      expect(flash[:notice]).to be_present
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to new' do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to new_user_path
    end

    it 'redirects with a notice' do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to be_present
    end
  end
end
