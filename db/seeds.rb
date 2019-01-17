(1..30).each do |value|
  User.create(email: "email_#{value}@example.com", username: "username_#{value}")
end
