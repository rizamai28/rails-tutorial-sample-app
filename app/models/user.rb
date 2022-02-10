class User < ApplicationRecord
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
end
