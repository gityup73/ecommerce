class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :categories, :brands, :line_items
  
  def categories
  	@categories = Category.all
  end

  def brands
  	@brands = Product.pluck(:brand).sort.uniq!
  end

  def line_items
  	@line_items = LineItem.all
  end

end
