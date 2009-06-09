class WysiwygPreviewsController < ApplicationController
  def show
    # Filter message parameter and render
    @preview = WysiwygPreview.new(params[:message]).filter
  end
end
