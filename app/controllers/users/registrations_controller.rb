# frozen_string_literal: true
require 'json'
require 'open-uri'
require 'nokogiri'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
     super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
      TeaMailer.welcome_email(resource).deliver_now!

    # create_poem
    create_poem(resource)
    TeaMailer.daily_poem(resource).deliver_now!

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def create_poem(resource)
    url = "https://poetry-api.herokuapp.com/"
    html_doc = Nokogiri::HTML(open(url))
    last_num = html_doc.search('span#last-p').text.strip
    num = rand(1..last_num)
    url = "http://poetry-api.herokuapp.com/api/v1/poems/#{num}"
    poem_serialized = open(url).read
    poem = JSON.parse(poem_serialized)
    author = poem['author']['name']
    title = poem['title']
    content = poem['content']
    Poem.create(user_id: resource.id, author: author, title: title, content: content)
  end
end
