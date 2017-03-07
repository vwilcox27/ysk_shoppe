class ArtController < ApplicationController

  def art
    @art = Shoppe::Art.root.ordered.includes(:product_categories, :variants)
    @art = @art.group_by(&:art_category)
  end
  def show
    @art = Shoppe::Art.root.find_by_permalink(params[:permalink])
  end

end
