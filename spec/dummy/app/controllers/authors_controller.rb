# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[edit update destroy]

  def index
    @authors = Author.order(id: :desc)
  end

  def new
    @author = Author.new
    @author.initialize_active_values
  end

  def create
    @author = Author.new
    @author.assign_attributes(author_params)

    if @author.save
      redirect_to edit_author_path(@author), status: :see_other
    else
      @author.initialize_active_values
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @author.initialize_active_values
  end

  def update
    if @author.update(author_params)
      redirect_to edit_author_path(@author), status: :see_other
    else
      @author.initialize_active_values
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy!

    redirect_to authors_path, status: :see_other
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    permitted_params = params.require(:author).permit(
      :name,
      :group_id,
      active_values_attributes: [:id, :active_field_id, :value, :_destroy, value: []],
    )
    permitted_params[:active_values_attributes].each do |_index, value_attrs|
      value_attrs[:value] = compact_array_param(value_attrs[:value]) if value_attrs[:value].is_a?(Array)
    end

    permitted_params
  end
end
