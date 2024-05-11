# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: "Post" do
    sequence(:title) { |n| "Post #{n}" }
    sequence(:body) { |n| "Body #{n}" }
  end

  factory :comment, class: "Comment" do
    post
    sequence(:body) { |n| "Body #{n}" }
  end
end
