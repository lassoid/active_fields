# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[edit update destroy]

  def index
    @authors = Author.order(id: :desc)
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new
    @author.assign_attributes(author_params)

    if @author.save
      redirect_to edit_author_path(@author), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @author.update(author_params)
      redirect_to edit_author_path(@author), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy

    redirect_to authors_path, status: :see_other
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    active_fields_permitted = active_fields_permitted_attributes(@author)
    permitted_params = params.require(:author).permit(
      :name,
      :group_id,
      active_values_attributes: active_fields_permitted,
    )
    permitted_params[:active_values_attributes] = compact_array_params(
      permitted_params[:active_values_attributes],
      active_fields_permitted,
    )

    permitted_params
  end
end
