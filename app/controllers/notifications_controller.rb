class NotificationsController < ApplicationController
  def index
    render json: { message: "Book notifications fetched successfully" }
  end
end
