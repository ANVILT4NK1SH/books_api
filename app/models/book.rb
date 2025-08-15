class Book < ApplicationRecord
  after_commit :broadcast_book_event, on: [ :create, :update ]
  include Rails.application.routes.url_helpers
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :author, presence: true
  validates :read, inclusion: { in: [ true, false ] }

  def cover_image_url
    rails_blob_url(self.cover_image, only_path: false) if self.cover_image.attached?
  end

  private

  def broadcast_book_event
    Pusher.trigger("books-channel", "book-changed", {
      id: self.id,
      title: self.title,
      author: self.author,
      cover_image_url: self.cover_image_url
    })
  end
end
