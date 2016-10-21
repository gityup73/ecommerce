class CartController < ApplicationController

before_action :authenticate_user!, only: [:checkout]

  def add_to_cart
  	line_item = LineItem.new
  	line_item.product_id = params[:product_id]
  	line_item.quantity = params[:quantity]
    
    if line_item.quantity.nil?
      redirect_to root_path
    else
        line_item.line_item_total = line_item.product.price * line_item.quantity
        line_item.save
        redirect_to view_order_path
    end
    

  end #end add to cart

  def view_order
  		@line_items = LineItem.all
  end #end view_order

  def checkout
    @line_items = LineItem.all
    @order = Order.new
    @order.user_id = current_user.id

    sum = 0

    if @line_items.empty?
      redirect_to root_path
    else
      #load the order_items hash with quantity value
      # if we don't currently have the item in the line-items table, push it to table, else add the quantity to existing line_item
      @line_items.each do |line_item|
        if @order.order_items[line_item.product_id].nil?
          @order.order_items[line_item.product_id] = line_item.quantity
        else
          @order.order_items[line_item.product_id] += line_item.quantity
        end

        sum += line_item.line_item_total

    end #end if @line_items.empty?


    @order.subtotal = sum
    @order.sales_tax = sum * 0.08
    @order.grand_total = @order.subtotal + @order.sales_tax
    @order.save

    # reduce inventory in product table
    @line_items.each do |line_item|
      line_item.product.quantity -= line_item.quantity
      line_item.product.save
    end #end loop

    

  end #end def checkout

  def order_complete
    @order = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i
    # line item table emptied when checked out
    LineItem.destroy_all

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Tech Talent Store customer',
      :currency    => 'usd'
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to view_order_path
    end
  end
end #end class

