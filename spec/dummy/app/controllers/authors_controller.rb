# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[edit update destroy]

  def index
    @authors = Author.where_active_fields(active_fields_finders_params)
      .includes(active_values: :active_field).order(id: :desc)
  end

  def new
    @author = Author.new
  end

  def edit; end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to edit_author_path(@author), status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @author.update(author_params)
      redirect_to edit_author_path(@author), status: :see_other
    else
      render :edit, status: :unprocessable_content
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
    permitted_params = params.expect(
      author: [
        :name,
        :group_id,
        active_fields_attributes: [:name, :value, :_destroy, value: []],
      ],
    )
    permitted_params[:active_fields_attributes]&.each do |_index, value_attrs|
      value_attrs[:value] = compact_array_param(value_attrs[:value]) if value_attrs[:value].is_a?(Array)
    end

    permitted_params
  end
end
