require 'rails_helper'

RSpec.describe TestCasesController, type: :controller do

  describe "GET #index" do
    let(:question) { create(:question) }
    subject { get :index, params: { question_id: question } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders index view" do
        expect(response).to render_template(:index)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #new" do
    let(:question) { create(:question) }
    subject { get :new, params: { question_id: question } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders new view" do
        expect(response).to render_template(:new)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST #create" do
    let(:question) { create(:question) }
    subject(:post_with_valid_attributes) { post :create,
             params: { test_case: attributes_for(:test_case),
                       question_id: question } }

    context "when logged-in -->" do
      before { sign_in create(:user) }

      context "whit valid attributes" do
        it "creates a new object" do
          expect{ post_with_valid_attributes }.to change(TestCase, :count).by(1)
        end
      end

      context "whit invalid attributes" do
        subject(:post_with_invalid_attributes) { post :create,
                params: {
                test_case:
                attributes_for(:test_case, output: nil),
                question_id: question } }

        it "does not save the new object" do
          expect{ post_with_invalid_attributes }.to_not change(TestCase, :count)
        end
      end
    end

    context "when not logged-in" do
      before { post_with_valid_attributes }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #show" do
    let(:test_case) { create(:test_case) }
    subject { get :show, params: { id: test_case } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders show view" do
        expect(response).to render_template(:show)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET #edit" do
    let(:test_case) { create(:test_case) }
    subject { get :edit,
              params: {
              id: test_case,
              test_case: test_case } }

    context "when logged-in" do
      before do
        sign_in create(:user)
        subject
      end

      it "renders edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT #update" do
    let(:test_case) { create(:test_case) }

    context "when logged-in -->" do
      before { sign_in create(:user) }

      context "whit valid attributes" do
        subject { put :update, params: {
                  id: test_case,
                  test_case: attributes_for(:test_case, output: "New output") } }

        it "updates object attributes" do
          subject
          expect(test_case.reload.output).to eq("New output")
        end
      end

      context "whit invalid attributes" do
        before { put :update, params: {
                 id: test_case,
                 test_case: attributes_for(:test_case, output: nil) } }

        it "does not update object attributes" do
          expect(test_case.reload.output).to_not be_nil
        end
      end
    end

    context "when not logged-in" do
      before { put :update, params: {
               id: test_case,
               question: attributes_for(:question, description: "New description") } }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:test_case) { create(:test_case) }
    subject { delete :destroy, params: { id: test_case } }

    context "when logged-in" do
      before { sign_in create(:user) }

      it "deletes the object" do
        expect { subject }.to change(TestCase, :count).by(-1)
      end
    end

    context "when not logged-in" do
      before { subject }

      it "redirects to sign-in page" do
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
