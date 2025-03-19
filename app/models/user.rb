class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  # ハッシュかしたパスワードをデータベースのpassword_digest属性に保存できる。
  # 電子署名でやった。
  # authenticateメソッドが使えるようになる。
  validates :password, presence: true, length: { minimum: 8 }

  class << self
    def digest(string)
      # クラスメソッドの定義
      # ここでのselfはUserクラス自体を指す。
      # テスト用の仮のアカウント登録をする。
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      # テスト中はコストパラメータを最小にし、本番環境では通常の高いコストで計算する。
      BCrypt::Password.create(string, cost: cost)
      # ここでパスワードのハッシュが生成されている。
      # costが大きいほどパスワードのハッシュが複雑になり、解読に時間がかかる。
    end

    def new_token
      SecureRandom.urlsafe_base64
      # ランダムなトークンを生成する。
      # このトークンは実行するたびに違うものが出力される。
    end
  end

  def remember
    self.remember_token = User.new_token
    # selfを書くことによって、remember_tokenという名前の属性を作成している。
    update_attribute(:remember_digest, User.digest(remember_token))
    # このattributeが属性に対応している。
    # remember_digestっていう表の属性に対して、digestメソッドを使用することでremember_tokenをハッシュ化して代入している。
    remember_digest
    # ここのremember_digestはdbの記憶ダイジェストをメソッドの返り値として返している。
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    # ここでのremember_tokenは一番上で定義されたattr_accessor :remember_tokenとは異なる
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 記憶ダイジェストをクリアにする。
  def forget
    update_attribute(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
    # rememberメソッドが呼び出されて戻り値がremember_digestだから確定でtrueになる。
  end

end
