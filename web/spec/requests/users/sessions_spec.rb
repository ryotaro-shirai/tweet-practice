require 'rails_helper'

RSpec.describe "Users::Session", type: :request do
  let(:password) { "password" }
  let!(:user) { create(:user, password: password) }
  describe "POST /users/sign_in" do
    context "有効なパラメータの場合" do
      it "サインインしてリダイレクトする" do
        post user_session_path, params: {
          user: { email: user.email, password: password }
        }
        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(user)
      end
    end

    context "無効なパラメータの場合" do
      subject { post user_session_path, params: { user: { email: email, password: pwd } } }

      context "メールアドレスが空の場合" do
        let!(:email) { "" }
        let!(:pwd) { password }
        it "422を返し、未認証のまま" do
          subject
          expect(response).to have_http_status(422)
          expect(controller.current_user).to eq(nil)
        end
      end

      context "メールアドレスが間違っている場合" do
        let!(:email) { user.email }
        let!(:pwd) { "wrong_password" }
        it "422を返し、未認証のまま" do
          subject
          expect(response).to have_http_status(422)
          expect(controller.current_user).to eq(nil)
        end
      end

      context "メールアドレスが存在しないメールアドレスの場合" do
        let!(:email) { "no_exist@example.com" }
        let!(:pwd)   { password }
        it "422を返し、未認証のまま" do
          subject
          expect(response).to have_http_status(422)
          expect(controller.current_user).to eq(nil)
        end
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "サインアウトしてリダイレクトして未認証状態になる" do
        delete destroy_user_session_path
        expect(response).to redirect_to(root_path)
        expect(controller.current_user).to eq(nil)
      end
    end
  end
end
