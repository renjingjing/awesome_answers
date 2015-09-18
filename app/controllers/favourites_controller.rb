class FavouritesController < QuestionNestingsController

  def create
    favourite = Favourite.new(question: @question, user: current_user)
    respond_to do |format|
    if favourite.save
      format.html { redirect_to }
      format.js   { render }
      # redirect_to @question, notice: "Favourited!"
    else
      format.html { redirect_to }
      format.js   { render }
      # redirect_to @question, alert: "Can't Favourited!"
    end
  end
  end

  def destroy
    favourite = Favourite.find params[:id]
    respond_to do |format|
    if can? :destroy, favourite
      favourite.destroy
      format.html { redirect_to }
      format.js   { render }
      # redirect_to @question, notice: "Removed Favourite Status"
    else
      format.html { redirect_to }
      format.js   { render }
      # redirect_to root_path, alert: "access denied"
    end
  end
  end

end
