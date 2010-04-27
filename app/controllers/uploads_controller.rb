class UploadsController < ApplicationController
  protect_from_forgery :except => 'upload'
  def upload
    FileUtils.mv params[:file].path, RAILS_ROOT+"/data/#{params[:Filename]}"
    return render :nothing => 200
  end
end
