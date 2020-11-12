class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  # user will only be required once to sign up for the site
  has_one :payment
  # user accepts the payment attributes as well upon form submission
  # will hit the payments table at the same time the users table is hit
  accepts_nested_attributes_for :payment
  has_many :images
end
