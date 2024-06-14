class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @sub_categories = SubCategory.all
    renden json: @sub_categories
  end

  def show
    render json: @sub_category
  end

  def new
    @sub_category = SubCategory.new
    end

    def edit
      end

      def create
        @sub_category = SubCategory.new(sub_category_params)
        if @sub_category.save
          render json: @sub_category, status: :created, location: @sub_category
          else
            render json: @sub_category.errors, status: :unprocessable_entity
        end
      end

      def update
        if @sub_category.update(sub_category_params)
          render json: @sub_category
          else
            render json: @sub_category.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @sub_category.destroy
        render json: { message: 'SubCategory was successfully deleted.' }, status: :no_content
        end

        private

        def set_sub_category
          @sub_category = SubCategory.find(params[:id])
        end

          def sub_category_params
            params.require(:sub_category).permit(:name, :category_id)
          end
        end
