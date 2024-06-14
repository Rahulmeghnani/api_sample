class ProductsController < ApplicationController
  before_action :authorize_request
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:destroy]

  def index
    @products = Product.all
    render json: @products
  end

  def show
    render json: @product, status: :ok
  end

  def create
    
    @product = @current_user.products.build(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: { message: 'Product deleted successfully' }, status: :ok
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def check_owner
    unless @product.user_id == @current_user.id
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    end
  end
end
