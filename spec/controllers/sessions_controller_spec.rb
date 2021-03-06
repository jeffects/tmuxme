require 'rails_helper'

describe SessionsController do
  describe "POST create" do
    it "finds a user by email" do
      email = "some email"
      expect(User).to receive(:find_by_email).with(email).and_return(double.as_null_object)
      post :create, :email => email
    end

    context "when user is found by email" do
      let(:user) { double(:id => 'some id') }
      before do
        allow(User).to receive(:find_by_email).and_return(user)
      end

      context "when found user is authenticated" do
        before do
          allow(user).to receive(:authenticate).and_return(true)
        end

        it "sets the users id in the session" do
          post :create, :email => 'dont_care'
          expect(session[:user_id]).to eq('some id')
        end
      end

      context "when found user is NOT authenticated" do
        before do
          allow(user).to receive(:authenticate).and_return(false)
        end

        it "sets the flash now error message" do
          post :create, :email => 'dont_care'
          expect(flash.now[:error]).to eq 'Email or password is invalid!'
        end

        it "renders the new template" do
          post :create, :email => 'dont_care'
          expect(response).to render_template('new')
        end
      end
    end

    context "when user is NOT found by email" do
      before do
        allow(User).to receive(:find_by_email).and_return(nil)
      end

      it "sets the flash now error message" do
        post :create, :email => 'dont_care'
        expect(flash.now[:error]).to eq 'Email or password is invalid!'
      end

      it "renders the new template" do
        post :create, :email => 'dont_care'
        expect(response).to render_template('new')
      end
    end
  end
end
