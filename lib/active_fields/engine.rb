# frozen_string_literal: true

module ActiveFields
  class Engine < ::Rails::Engine
    isolate_namespace ActiveFields

    config.eager_load_namespaces << ActiveFields

    initializer "active_fields.active_record" do
      ActiveSupport.on_load(:active_record) do
        include HasActiveFields
      end
    end
  end
end
