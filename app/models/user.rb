class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_rooms
  has_many :chats
  has_many :rooms,through: :user_rooms


  has_many :books,dependent: :destroy
  has_many :groups_users
  # ↓userは,group_usersという中間テーブルを通じてgroupsにアクセスできるという
  has_many :groups,through: :group_users
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :follower,class_name: "Relationship",foreign_key: "follower_id",dependent: :destroy
  has_many :followed,class_name: "Relationship",foreign_key: "followed_id",dependent: :destroy
  has_many :following_user,through: :follower, source: :followed
  has_many :follower_user,through: :followed, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  validates :introduction,length: {maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_user.include?(user)
  end

  def self.looks(search,word)
    if search =="perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
