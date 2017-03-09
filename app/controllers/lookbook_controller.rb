class LookbookController < ApplicationController
  def lookbook
    @lookbook = Shoppe::Lookbook.root.ordered.includes(:product_categories, :variants)
    @lookbook = @lookbook.group_by(&:lookbook_category)
  end
  def show
    # @contact = Shoppe::Contact.root.find_by_permalink(params[:permalink])
  end
end
