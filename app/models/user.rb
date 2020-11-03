class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :poem, dependent: :destroy

=begin
  def self.send_daily_poem
    User.all.each do |user|
      TeaMailer.daily_poem(user).deliver_now!
    end
  end
=end
end
