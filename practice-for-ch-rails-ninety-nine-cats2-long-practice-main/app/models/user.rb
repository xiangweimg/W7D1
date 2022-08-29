# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null #why session_token
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    attr_accessor :password
    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: { message: "Password can't be blank"}
    validates :password, length: {minimum: 6, allow_nil: true}

    before_validation :ensure_session_token

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        #new is creating a password_digest
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
        #new is creating an object
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64

        while User.exists?(session_token: token) #if this token already exists
            token = SecureRandom::urlsafe_base64
        end
        token
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    


end
