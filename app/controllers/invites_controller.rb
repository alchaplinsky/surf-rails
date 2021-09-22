class InvitesController < ApplicationController

  def show
    @invite = Invite.pending.find_by_token! params[:id]
  end

end
