# frozen_string_literal: true

class Image::UserAvatar < ViewComponent::Base
  def initialize(user:, klasses: '')
    @user = user
    @klasses = klasses
  end
end
