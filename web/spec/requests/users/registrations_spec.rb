require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "POST /users" do
    context "有効なパラメータの場合" do
      it "ユーザーを作成してリダイレクトする" do
        post user_registration_path, params: {
          user: { email: "test@example.com", password: "password", password_confirmation: "password" }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context "無効なパラメータの場合" do
      it "ユーザーを作成しない" do
        expect {
          post user_registration_path, params: {
            user: { email: "", password: "password", password_confirmation: "password" }
          }
        }.not_to change(User, :count)
      end
    end
  end
end
