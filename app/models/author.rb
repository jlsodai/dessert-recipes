class Author < ActiveRecord::Base
    attr_accessor :remember_token
    
    has_many :recipes
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name,            presence: true,
                                length: { maximum: 50 }

    validates :username,        presence: true
    
    validates :email,           presence: true,
                                length: { maximum: 255 },
                                format: { with: VALID_EMAIL_REGEX },
                                uniqueness: { case_sensitive: false }
    
    has_attached_file :image, styles: { author_image: "350x250#", medium: "400x400#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
                                
    validates_attachment_content_type :image,
                                content_type: /\Aimage\/.*\Z/
    
    has_secure_password
    validates :password,        presence: true,
                                length: {minimum: 6},
                                allow_nil: true
                                
    def Author.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def Author.new_token
        SecureRandom.urlsafe_base64
    end
    
    # Remembers an author in the database for use in persistent sessions.
    def remember
        self.remember_token = Author.new_token
        update_attribute(:remember_digest, Author.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    # Forgets an author.
    def forget
        update_attribute(:remember_digest, nil)
    end
end