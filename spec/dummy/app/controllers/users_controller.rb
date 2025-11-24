# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.where_active_fields(active_fields_finders_params, scope: params[:tenant_id])
      .includes(active_values: :active_field).order(id: :desc)

    @users = @users.where(tenant_id: params[:tenant_id]) if params[:tenant_id]
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to edit_user_path(@user), status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!

    redirect_to users_path, status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted_params = params.expect(
      user: [
        :email,
        :tenant_id,
        active_fields_attributes: [:name, :value, :_destroy, value: []],
      ],
    )
    permitted_params[:active_fields_attributes]&.each do |_index, value_attrs|
      value_attrs[:value] = compact_array_param(value_attrs[:value]) if value_attrs[:value].is_a?(Array)
    end

    permitted_params
  end
end
