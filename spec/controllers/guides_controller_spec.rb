require 'rails_helper'

RSpec.describe GuidesController, active_mocker: true do
  let(:user) { Fabricate :user }
  before(:each) { sign_in user }

  describe '#new' do
    render_views
    it 'returns successfully' do
      get :new
      expect(response).to be_success
    end
  end

  describe '#create' do
    let(:guide_params) {{ guide: { name: 'What a great guide' }}}
    it 'creates a new guide' do
      expect{ post :create, guide_params }.to change{ Guide.count }.by(1)
    end
    it 'redirects to edit' do
      post :create, guide_params
      expect(response).to be_redirect
    end
    it 'assigns the creating user permission' do
      post :create, guide_params
      expect(assigns(:guide).users).to include(user)
    end
    context 'with views' do
      render_views
      it 'renders new with errors' do
        post :create, { guide: { foo: 2 }}
        expect(response).to render_template(:new)
        expect(assigns(:guide).errors.messages).to eq(name: ["can't be blank"])
      end
    end
  end

  context 'with a guide' do
    let(:guide) { Fabricate :guide, users: [user] }

    describe '#show' do
      render_views
      it 'renders successfully' do
        get :show, { id: guide.id }
        expect(response).to be_success
      end
    end
    describe '#fields' do
      render_views
      it 'renders successfully' do
        get :fields, { id: guide.id }
        expect(response).to be_success
      end
    end
    describe '#edit' do
      render_views
      it 'renders successfully' do
        get :edit, { id: guide.id }
        expect(response).to be_success
      end
    end
  end

  describe '#update'

  describe '#invite' do
    render_views
    let(:guide) { Fabricate :guide, users: [user] }
    before(:each) { get :invite, { id: guide.id } }
    it 'renders successfully' do
      expect(response).to be_success
    end
  end

  describe '#users' do
    let(:guide) { Fabricate :guide, users: [user] }
    let(:email) { 'bob@example.com' }
    it 'adds a user to the guide' do
      expect(User).to receive(:invite)
                      .with(email, guide, user.first_name)
                      .and_return(instance_double(User, valid?: true))

      post :users, { id: guide.id, email: email }
    end
  end

  describe '#show'
end
