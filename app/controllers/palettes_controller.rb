require "json"

class PalettesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_palette, only: %i[show edit update destroy]

  # GET /palettes or /palettes.json
  def index
    render json: Palette.all, include: [:colors]
  end

  # GET /palettes/1 or /palettes/1.json
  def show
  end

  # GET /palettes/new
  def new
    @palette = Palette.new
  end

  # GET /palettes/1/edit
  def edit
  end

  def random
    @count = params[:count].to_i || 1
    @color_count = params[:per_palette].to_i || 5

    @seed_rgbs = []
    @count.times.each { @seed_rgbs << PalettesController.helpers.find_random_unique_color(@seed_rgbs) }

    @seed_hexes = @seed_rgbs.map { |rgb| ColorsController.helpers.rgb_to_hex(*rgb) }

    @palettes =
      @seed_hexes.map do |seed|
        palette = Palette.new(name: PalettesController.helpers.random_palette_name)
        palette.colors.push(*PalettesController.helpers.generate_color_palette_v3(seed, @color_count).map { |hex| Color.new(hex: hex) })
        palette
      end

    render json: @palettes, include: [:colors]
  end

  # POST /palettes or /palettes.json
  def create
    @colors = params[:colors]
    @colors.map! { |color| Color.where(hex: color[:hex]).first_or_create }
    @palette = Palette.create(name: params[:name], colors: @colors)

    # respond_to do |format|
    #   if @palette.save
    #     render json: @palette, status: :created
    #   else
    #     render json: @palette.errors, status: :unprocessable_entity
    #   end
    # end
  end

  # PATCH/PUT /palettes/1 or /palettes/1.json
  def update
    respond_to do |format|
      if @palette.update(palette_params)
        format.html { redirect_to palette_url(@palette), notice: "Palette was successfully updated." }
        format.json { render :show, status: :ok, location: @palette }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @palette.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /palettes/1 or /palettes/1.json
  def destroy
    @palette = Palette.find(params[:id])
    @palette.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_palette
    @palette = Palette.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def palette_params
    params.require(:palette).permit(:name)
  end
end
