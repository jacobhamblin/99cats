class CatsController < ApplicationController
  before_action :check_owner, except: [:show, :new, :create, :index]

  def index
    @cats = Cat.all
#    render json: @cats
  end

  def show
    @cats = Cat.all
    @cat = @cats.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      flash[:notice] = "Created #{@cat.name}"
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cats = Cat.all
    @cat = @cats.find(params[:id])
    render :edit
  end

  def destroy
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private
  def cat_params
    params[:cat].permit(
      :name, :birth_date, :color, :description, :sex
    )
  end

  def check_owner
    @cats = Cat.all
    @cat = @cats.find(params[:id])
    if @cat.user_id == current_user.id
      return true
    else
      flash[:notice] = "This isn't your cat..."
      redirect_to cat_url(@cat)
    end
  end
end
