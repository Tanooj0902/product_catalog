FactoryGirl.define do
  factory :product do
    # Adding timestamp so there are no repeated names.
    # While this does not guarantee uniq name but works for now.
    name { "#{Faker::Lorem.word}_#{Time.now.to_f}" }
    description { Faker::Lorem.word }
    price { Faker::Number.number(2) }
  end
end
