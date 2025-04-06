class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
  # dependent: :destroy => ユーザーが削除されたら、関連するマイクロポストも削除する．
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  # ハッシュかしたパスワードをデータベースのpassword_digest属性に保存できる。
  # 電子署名でやった。
  # authenticateメソッドが使えるようになる。
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    # ここでのremember_tokenは一番上で定義されたattr_accessor :remember_tokenとは異なる
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 記憶ダイジェストをクリアにする。
  def forget
    update_attribute(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
    # rememberメソッドが呼び出されて戻り値がremember_digestだから確定でtrueになる。
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_send_at: Time.zone.now)
    # self.reset_tokenの省略
    # reset_digestにはハッシュ化されたreset_tokenが代入
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_send_at < 2.hours.ago
    # reset_send_at < 2hoursでtrue
    # Sun, 30 Mar 2025 11:58:27.083875000 UTC +00:00
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
