FactoryBot.define do
    factory :user do
      email { 'test@example.com' }
      password { "password123" }
      password_confirmation { "password123" }
      admin {true}
    end
  end