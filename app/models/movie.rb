class Movie < ApplicationRecord
    mount_uploader :image_path, ImageUploader
    # belongs_to :user   # 이미 1:m 관계가 있음
    has_many :likes
    has_many :users, through: :likes
    has_many :comments
end
