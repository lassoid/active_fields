# frozen_string_literal: true

class ActiveFieldsController < ApplicationController
  before_action :set_active_field, only: %i[show edit update destroy]

  def index
    @active_fields = ActiveFields.config.field_base_class.order(:customizable_type, :id)
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
    params.require(:active_field).permit(*permitted_attributes_for_create(model_class)).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  def active_field_update_params(model_class)
    params.require(:active_field).permit(*permitted_attributes_for_update(model_class)).tap do |attrs|
      attrs.transform_values! do |value|
        value.is_a?(Array) ? compact_array_param(value) : value
      end
    end
  end

  # It is strongly recommended to move it to, for example, policies.
  def permitted_attributes_for_create(model_class)
    if model_class == ActiveFields::Field::Boolean
      %i[customizable_type name required nullable default_value]
    elsif model_class == ActiveFields::Field::Date
      %i[customizable_type name required min max default_value]
    elsif model_class == ActiveFields::Field::DateArray
      [:customizable_type, :name, :min_size, :max_size, :min, :max, default_value: []]
    elsif model_class == ActiveFields::Field::DateTime
      %i[customizable_type name required min max precision default_value]
    elsif model_class == ActiveFields::Field::DateTimeArray
      [:customizable_type, :name, :min_size, :max_size, :min, :max, :precision, default_value: []]
    elsif model_class == ActiveFields::Field::Decimal
      %i[customizable_type name required min max precision default_value]
    elsif model_class == ActiveFields::Field::DecimalArray
      [:customizable_type, :name, :min_size, :max_size, :min, :max, :precision, default_value: []]
    elsif model_class == ActiveFields::Field::Enum
      [:customizable_type, :name, :required, :default_value, allowed_values: []]
    elsif model_class == ActiveFields::Field::EnumArray
      [:customizable_type, :name, :min_size, :max_size, allowed_values: [], default_value: []]
    elsif model_class == ActiveFields::Field::Integer
      %i[customizable_type name required min max default_value]
    elsif model_class == ActiveFields::Field::IntegerArray
      [:customizable_type, :name, :min_size, :max_size, :min, :max, default_value: []]
    elsif model_class == ActiveFields::Field::Text
      %i[customizable_type name min_length max_length default_value]
    elsif model_class == ActiveFields::Field::TextArray
      [:customizable_type, :name, :min_size, :max_size, :min_length, :max_length, default_value: []]
    else
      raise ArgumentError, "undefined model_class `#{model_class.inspect}`"
    end
  end

  # It is strongly recommended to move it to, for example, policies.
  def permitted_attributes_for_update(model_class)
    if model_class == ActiveFields::Field::Boolean
      %i[name default_value]
    elsif model_class == ActiveFields::Field::Date
      %i[name default_value]
    elsif model_class == ActiveFields::Field::DateArray
      [:name, default_value: []]
    elsif model_class == ActiveFields::Field::DateTime
      %i[name default_value]
    elsif model_class == ActiveFields::Field::DateTimeArray
      [:name, default_value: []]
    elsif model_class == ActiveFields::Field::Decimal
      %i[name default_value]
    elsif model_class == ActiveFields::Field::DecimalArray
      [:name, default_value: []]
    elsif model_class == ActiveFields::Field::Enum
      %i[name default_value]
    elsif model_class == ActiveFields::Field::EnumArray
      [:name, default_value: []]
    elsif model_class == ActiveFields::Field::Integer
      %i[name default_value]
    elsif model_class == ActiveFields::Field::IntegerArray
      [:name, default_value: []]
    elsif model_class == ActiveFields::Field::Text
      %i[name default_value]
    elsif model_class == ActiveFields::Field::TextArray
      [:name, default_value: []]
    else
      raise ArgumentError, "undefined model_class `#{model_class.inspect}`"
    end
  end

  def set_active_field
    @active_field = ActiveFields.config.field_base_class.find(params[:id])
  end

  def model_class
    (ActiveFields.config.fields[params[:type]&.to_sym] || ActiveFields.config.type_class_names.first).constantize
  end
end
