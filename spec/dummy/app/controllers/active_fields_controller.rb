# frozen_string_literal: true

class ActiveFieldsController < ApplicationController
  before_action :set_active_field, only: %i[edit update destroy]

  def index
    @active_fields = ActiveFields.config.field_base_class.order(:customizable_type, :id)
  end

  def new
    @active_field = model_class.new
  end

  def create
    @active_field = model_class.new(active_field_create_params(model_class))

    if @active_field.save
      redirect_to edit_active_field_path(@active_field), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @active_field.update(active_field_update_params(@active_field.class))
      redirect_to edit_active_field_path(@active_field), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @active_field.destroy!

    redirect_to active_fields_path, status: :see_other
  end

  private

  def active_field_create_params(model_class)
    params.require(:active_field).permit(policy(model_class).permitted_attributes_for_create).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  def active_field_update_params(model_class)
    params.require(:active_field).permit(policy(model_class).permitted_attributes_for_update).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  def set_active_field
    @active_field = ActiveFields.config.field_base_class.find(params[:id])
  end

  def model_class
    (ActiveFields.config.fields[params[:type]&.to_sym] || ActiveFields.config.fields.values.first).constantize
  end
end
