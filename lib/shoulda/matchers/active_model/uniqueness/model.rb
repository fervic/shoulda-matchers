module Shoulda
  module Matchers
    module ActiveModel
      module Uniqueness
        # @private
        class Model
          def self.next_unique_copy_of(existing_model_name, root_namespace)
            model = new(existing_model_name, root_namespace)

            while model.already_exists?
              model = model.next
            end

            model
          end

          def initialize(full_name, root_namespace)
            @full_name = full_name
            @root_namespace = root_namespace
            @namespace = root_namespace.add(full_name_parts[0..-2])
            @name = full_name_parts.last
          end

          def already_exists?
            namespace.has?(name)
          end

          def next
            Model.new(full_name.next, root_namespace)
          end

          def symlink_to(parent)
            namespace.set(name, parent.dup)
          end

          def to_s
            [root_namespace, full_name].join('::')
          end

          protected

          attr_reader :parent, :root_namespace, :full_name, :namespace, :name

          private

          def full_name_parts
            full_name.split('::')
          end
        end
      end
    end
  end
end
