class OrdersController < ApplicationController
  def index
    @orders = Order.all
    render json: orders
  end

  def show
    @order = Order.find(params[:id])
    render json: order
  end

  def create
    @order = Order.new(order_params)
    @order.total_price = calculate_total_price(@order.order_items)
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, order_items_attributes: [:product_id, :quantity])
    end

     def calculate_total_price(order_items)
      order_items.sum { |item| item.product.price * item.quantity }
  end
end
