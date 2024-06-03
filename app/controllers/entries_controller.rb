class EntriesController < ApplicationController
  def day_popup_form
    @entry = Entry.find(params[:id])
  end

  def create

  end
end
