class User < ActiveRecord::Base

	before_create :create_remember_token
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

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end


	private
		#adding extra tabs for stuff after private makes sure you remember
		#that these are private methods
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

end
