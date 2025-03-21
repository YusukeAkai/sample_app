# メインのサンプルユーザーを1人作成する
User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'foobarrr',
             password_confirmation: 'foobarrr',
             admin: true)

User.create!(name: 'akagi',
             email: 'akagiyusuke@icloud.com',
             password: 'akagiyusuke',
             password_confirmation: 'akagiyusuke')

# ここでのcreate!メソッドは、falseではなく例外を出力する。

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
