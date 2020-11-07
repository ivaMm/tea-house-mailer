require 'json'
require 'open-uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :poem, dependent: :destroy

  def self.send_daily_poem
    User.all.each do |user|
      num = rand(1..1095)
      url = "http://poetry-api.herokuapp.com/api/v1/poems/#{num}"
      poem_serialized = open(url).read
      poem = JSON.parse(poem_serialized)
      author = poem['author']['name']
      title = poem['title']
      content = poem['content']
      user.poem.update!(user_id: user.id, author: author, title: title, content: content)
      TeaMailer.daily_poem(user).deliver_now!
    end
  end
end
