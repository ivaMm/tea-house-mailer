require 'json'
require 'open-uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :poem, dependent: :destroy
  after_create :send_poem

  def send_poem
    Poem.create!(build_poem(self))
    TeaMailer.welcome_email(self).deliver_now!
    TeaMailer.daily_poem(self).deliver_now!
  end

  def self.send_daily_poem
    User.all.each do |user|
      # user.poem.update!(build_poem(user))
      url1 = "http://poetry-api.herokuapp.com/api/v1/poems/"
      serialized = open(url1).read
      poems = JSON.parse(serialized)
      last = poems['count']
      inx = rand(0...last)
      id = poems['poems'][inx]['id']
      url = "http://poetry-api.herokuapp.com/api/v1/poems/#{id}"
      poem_serialized = open(url).read
      poem = JSON.parse(poem_serialized)
      author = poem['author']['name']
      title = poem['title']
      content = poem['content']
      user.poem.update!(user_id: user.id, author: author, title: title, content: content)
      TeaMailer.daily_poem(user).deliver_now!
    end
  end

  def build_poem(user)
    id = random_poem
    url = "http://poetry-api.herokuapp.com/api/v1/poems/#{id}"
    poem_serialized = open(url).read
    poem = JSON.parse(poem_serialized)
    {
      user_id: user.id,
      author: poem['author']['name'],
      title: poem['title'],
      content: poem['content']
    }
  end

  def random_poem
    url = "http://poetry-api.herokuapp.com/api/v1/poems/"
    serialized = open(url).read
    poems = JSON.parse(serialized)
    last = poems['count']
    inx = rand(0...last)
    poems['poems'][inx]['id']
  end
end
