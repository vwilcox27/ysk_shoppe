class ContactController < ApplicationController
  def faq
    @contact = Shoppe::Contact.root.ordered.includes(:product_categories, :variants)
    @contact = @contact.group_by(&:art_category)
  end
  def show
    # @contact = Shoppe::Contact.root.find_by_permalink(params[:permalink])
  end

  end
