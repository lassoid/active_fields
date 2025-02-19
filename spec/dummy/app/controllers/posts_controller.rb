# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.where_active_values(active_fields_finders_params)
      .includes(active_values: :active_field).order(id: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to edit_post_path(@post), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to edit_post_path(@post), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!

    redirect_to posts_path, status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    permitted_params = params.require(:post).permit(
      :title,
      :body,
      :author_id,
      active_fields_attributes: [:name, :value, :_destroy, value: []],
    )
    permitted_params[:active_fields_attributes]&.each do |_index, value_attrs|
      value_attrs[:value] = compact_array_param(value_attrs[:value]) if value_attrs[:value].is_a?(Array)
    end

    permitted_params
  end
end
