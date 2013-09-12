class User < ActiveRecord::Base

	before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 50 }  
#	validates(:name, presence: true)  / this should also be the same as above
#	validates( :name, {presence: true} )  / moar of the same
#	validates( :name, {:presence => true} ) / same same!

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
				uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }
end
