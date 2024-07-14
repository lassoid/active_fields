# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update destroy]

  def index
    @groups = Group.order(id: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new
    @group.assign_attributes(group_params)

    if @group.save
      redirect_to edit_group_path(@group), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to edit_group_path(@group), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy

    redirect_to groups_path, status: :see_other
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
