module Shoulda
  module Matchers
    module ActiveModel
      module Uniqueness
        # @private
        module TestModels
          def self.create(model_name)
            existing_model = model_name.constantize
            new_model = Model.next_unique_copy_of(
              model_name,
              root_namespace
            )
            new_model.symlink_to(existing_model)
            new_model
          end

          def self.remove_all
            root_namespace.clear
          end

          def self.root_namespace
            @_root_namespace ||= Namespace.new_from_module(self)
          end
        end
      end
    end
  end
end
