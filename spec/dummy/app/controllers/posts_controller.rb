# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.order(id: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.assign_attributes(post_params)

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
    @post.destroy

    redirect_to posts_path, status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    active_fields_permitted = active_fields_permitted_attributes(@post)
    permitted_params = params.require(:post).permit(
      :title,
      :body,
      :author_id,
      active_values_attributes: active_fields_permitted,
    )
    permitted_params[:active_values_attributes] = compact_array_params(
      permitted_params[:active_values_attributes],
      active_fields_permitted,
    )

    permitted_params
  end
end