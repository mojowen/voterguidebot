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
    let(:guide_params) do
      {
        guide: {
          name: 'What a great guide',
          election_date: '11/8/2016',
          location_attributes: {
            address: 'Atlanta, GA',
            city: 'Atlanta',
            state: 'GA',
            lat: 47.000,
            lng: -135.000,
            north: 47.000,
            south: -135.000,
            east: 47.000,
            west: -135.000
          }
        }
      }
    end
    it 'creates a new guide' do
      expect{ post :create, guide_params }.to change{ Guide.count }.by(1)
    end
    it 'creates a new location' do
      expect{ post :create, guide_params }.to change(Location, :count).by(1)
      expect(assigns(:guide).location).to be_truthy
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
        expect(assigns(:guide).errors.messages).to include(name: ["can't be blank"])
      end
    end
    context 'cloning' do
      let!(:clone) { Fabricate :full_guide, users: [user] }

      it 'clones the guide' do
        post :create, { guide: { name: 'Different Guide' }, cloned_id: clone.id }

        expect(assigns(:guide).contests.length).to eq(clone.contests.length)
        expect(assigns(:guide).measures.length).to eq(clone.measures.length)
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
    describe '#update' do
      describe 'updating fields' do
        let(:guide_params) do
          {
            id: guide.id,
            guide: { fields: { title_page_header: 'what' } },
          }
        end
        it 'creates a field that is missing' do
          post :update, guide_params
          expect(guide.fields.first.value).to eq('what')
        end
        context 'with existing fields' do
          let!(:field) do
            Fabricate :field, guide: guide, value: 'Nope', field_template: 'title_page_header'
          end

          it 'creates a field that is missing' do
            post :update, guide_params
            expect(guide.fields.first.value).to eq('what')
          end
        end
      end
      describe 'updating guides' do
        let(:location) { Fabricate :location, guide: guide, city: 'Portland' }
        let(:city) { 'Atlanta' }
        let(:guide_params) do
          {
            id: guide.id,
            guide: {
              name: 'What a great guide',
              location_attributes: {
                address: 'Atlanta, GA',
                city: city,
                state: 'GA',
                lat: 47.000,
                lng: -135.000,
                north: 47.000,
                south: -135.000,
                east: 47.000,
                west: -135.000
              }
            }
          }
        end
        it 'updates the location' do
          post :create, guide_params
          expect(assigns(:guide).location.city).to eq(city)
        end
      end
    end
    describe '#invite' do
      render_views
      before(:each) { get :invite, { id: guide.id } }
      it 'renders successfully' do
        expect(response).to be_success
      end
    end
    describe '#users' do
      let(:email) { 'bob@example.com' }
      it 'adds a user to the guide' do
        expect(User).to receive(:invite)
                        .with(email, guide, user.first_name)
                        .and_return(instance_double(User, valid?: true))

        patch :users, { id: guide.id, email: email }
      end
    end
    describe '#show' do
      render_views
      it 'renders successfully' do
        get :show, { id: guide.id }
        expect(response).to be_success
      end
    end

    describe '#index' do
      it 'redirects to root' do
        get :index
        expect(response).to redirect_to root_path
      end

      context 'as admin' do
        let(:admin) { Fabricate :user, admin: true }
        let(:admin_guide) { Fabricate :guide }
        before(:each) { sign_in admin }

        it 'returns successfully' do
          get :index
          be_success
        end
      end
    end

    describe '#preview' do
      render_views
      before(:each) do
        2.times { Fabricate :measure, guide: guide }
        4.times { Fabricate :contest, guide: guide }
      end
      it 'renders successfully' do
        get :preview, { id: guide.id, version: guide.version }
        expect(response).to be_success
      end
    end

    describe '#destroy' do
      before(:each) { delete :destroy, { id: guide.id } }

      it 'archives a guide' do
        expect(guide.reload.active).to be(false)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    describe '#restore' do
      let(:guide) { Fabricate :guide, users: [user], active: false }
      before(:each) { delete :restore, { id: guide.id } }

      it 'archives a guide' do
        expect(guide.reload.active).to be(true)
      end

      it 'redirects to guide path' do
        expect(response).to redirect_to guide_path(guide)
      end
    end

    describe '#publish' do
      it 'sets the guide published_version to publishing' do
        post :publish, { id: guide.id }
        expect(guide.reload.published_version).to eq('publishing')
      end

      it 'redirects to guide path' do
        post :publish, { id: guide.id }
        expect(response).to redirect_to guide_path(guide)
      end

      it 'creates a delayed job' do
        expect do
          post :publish, { id: guide.id }
        end.to change(Delayed::Job, :count).by(1)
      end
    end

    describe '#archived' do
      render_views
      it 'returns successfully' do
        get :archived
        expect(response).to be_success
      end
    end

    describe "#validate" do
      let(:guide) { Fabricate :guide, template_name: :web }

      it "returns 200 if valid submission" do
        get :validate, url: 'something'
        expect(response).to be_success
      end

      it "returns not success if not valid submission" do
        get :validate, url: "#{guide.slug}"
        expect(response).to_not be_success
      end

      it "returns not success if not valid submission" do
        get :validate, url: "http://bad-url.here"
        expect(response).to_not be_success
      end
    end
  end
end
