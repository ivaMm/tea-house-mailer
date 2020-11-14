require 'json'
require 'open-uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :poem, dependent: :destroy
  after_create :send_welcome
  after_create :send_poem

  def send_welcome
    TeaMailer.welcome_email(self).deliver_now!
  end

  def send_poem
    create_poem(self)
    TeaMailer.daily_poem(self).deliver_now!
  end

  def self.send_daily_poem
    User.all.each do |user|
      id = random_id
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

  def create_poem(user)
    id = random_poem
    url = "http://poetry-api.herokuapp.com/api/v1/poems/#{id}"
    poem_serialized = open(url).read
    poem = JSON.parse(poem_serialized)
    author = poem['author']['name']
    title = poem['title']
    content = poem['content']
    Poem.create(user_id: user.id, author: author, title: title, content: content)
  end

  def random_poem
    url = "http://poetry-api.herokuapp.com/api/v1/poems/"
    serialized = open(url).read
    poems = JSON.parse(serialized)
    last = poems['count'] - 1 # get total number of poems (-1 bc indexes start from 0!)
    inx = rand(0..last)
    poems[inx]['id']
  end
end
