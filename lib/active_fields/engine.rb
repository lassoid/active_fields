# frozen_string_literal: true

module ActiveFields
  class Engine < ::Rails::Engine
    isolate_namespace ActiveFields

    config.eager_load_namespaces << ActiveFields

    # Disable reloading of models, as it breaks the STI.
    config.autoload_once_paths = %W[#{root}/app/models #{root}/app/models/concerns]

    initializer "active_fields.active_record" do
      ActiveSupport.on_load(:active_record) do
        include HasActiveFields
      end
    end
  end
end
