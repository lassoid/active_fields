# frozen_string_literal: true

module ActiveFields
  class Engine < ::Rails::Engine
    isolate_namespace ActiveFields

    initializer "active_fields.active_record" do
      ActiveSupport.on_load(:active_record) do
        include HasActiveFields
      end
    end

    initializer "active_fields.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include Helper
      end
    end
  end
end
