class TagsController < ApplicationController
  def index
    @tag = Tag.new
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    # @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_back_or_to :index, notice: "Tag was successfully created."
    else
      redirect_back_or_to :index, status: :unprocessable_entity, notice: @tag.errors.full_messages_for(:name).join(", ")
    end
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end
