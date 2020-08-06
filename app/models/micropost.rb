class Micropost < ApplicationRecord
  MICROPOSTS_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  scope :recent_posts, ->{order created_at: :desc}

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.validations.post.content_length}
  validates :image, content_type: {in: Settings.validations.post.content_type,
                                   message: I18n.t("microposts.image_format")},
                    size: {less_than: Settings.validations.post.max_file_size.megabytes,
                           message: I18n.t("microposts.image_size")}

  def display_image
    image.variant resize_to_limit: Settings.validations.post.resize_limit
  end
end
