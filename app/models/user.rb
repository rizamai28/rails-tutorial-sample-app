class User < ApplicationRecord
  attr_accessor :remember_token
  # DBに保存される前にemail属性を小文字にする ↓
  # Foo@ExAMPle.Comとfoo@example.comが別々の文字列だと認識させないため
  before_save { email.downcase! }
  # name属性が、空でない、最大文字数50文字
  validates :name, presence: true, length: { maximum: 50 }
  # 正しいemail属性の正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # email属性が、空でない、最大文字数255文字、フォーマットが正規表現であるか
  # 大文字小文字を区別せず一意であるか
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false }
  # セキュアなパスワードの実装
  has_secure_password
  # パスワードが空でない、最低文字数6文字
  validates :password, presence: true, length: { minimum: 6 }
  
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token # セッターメソッドを呼ぶためselfが必要
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)
  end
end
