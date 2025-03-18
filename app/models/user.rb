class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
  format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  # ハッシュかしたパスワードをデータベースのpassword_digest属性に保存できる。
  # 電子署名でやった。
  # authenticateメソッドが使えるようになる。
  validates :password, presence: true, length: {minimum: 8}

  def User.digest(string)
    # クラスメソッドの定義
    # テスト用の仮のアカウント登録をする。
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                              BCrypt::Engine.cost
    # テスト中はコストパラメータを最小にし、本番環境では通常の高いコストで計算する。
    BCrypt::Password.create(string, cost: cost)
    # ここでパスワードが生成されている。
    # costが大きいほどパスワードのハッシュが複雑になり、解読に時間がかかる。
  end
end
