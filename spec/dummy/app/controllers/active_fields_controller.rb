# frozen_string_literal: true

class ActiveFieldsController < ApplicationController
  before_action :set_active_field, only: %i[show edit update destroy]

  def index
    @active_fields = ActiveFields.config.field_base_class.order(:customizable_type, :scope, :id)
  end

  def show; end

  def new
    @active_field = model_class.new
  end

  def edit; end

  def create
    @active_field = model_class.new(active_field_create_params(model_class))

    if @active_field.save
      redirect_to edit_active_field_path(@active_field), status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @active_field.update(active_field_update_params(@active_field.class))
      redirect_to edit_active_field_path(@active_field), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @active_field.destroy!

    redirect_to active_fields_path, status: :see_other
  end

  private

  def active_field_create_params(model_class)
    params.expect(active_field: policy(model_class).permitted_attributes_for_create).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  def active_field_update_params(model_class)
    params.expect(active_field: policy(model_class).permitted_attributes_for_update).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  def set_active_field
    @active_field = ActiveFields.config.field_base_class.find(params[:id])
  end

  def model_class
    (ActiveFields.config.fields[params[:type]&.to_sym] || ActiveFields.config.type_class_names.first).constantize
  end
end
