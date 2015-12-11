class Comment < ActiveRecord::Base
    belongs_to :recipe
     validates  :name,  presence: true 
    					 length: { maximum: 50}
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    


    validates  :email, presence: true 
    					 length: { maximum: 255 },
                         format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
end


person.create(name: "Jane Doe").valid? # => True
person.create(name: nil).valid? # => False

