module Shoulda
  module Matchers
    module ActiveModel
      module Uniqueness
        # @private
        class Namespace
          def self.new_from_module(mod)
            parts = mod.to_s.split('::')
            new(parts, Object)
          end

          def initialize(parts, parent_constant)
            @parts = parts
            @parent_constant = parent_constant
          end

          def add(parts)
            self.class.new(parts, constant)
          end

          def has?(name)
            base_constant = parent_constant

            (parts + [name]).each do |part|
              unless base_constant.const_defined?(part, false)
                return false
              end

              base_constant = base_constant.const_get(part)
            end

            return true
          end

          def set(name, value)
            constant.const_set(name, value)
          end

          def clear
            constant.constants.each do |child_constant|
              constant.__send__(:remove_const, child_constant)
            end
          end

          def to_s
            ([parent_constant] + parts).join('::')
          end

          protected

          attr_reader :parts, :parent_constant

          private

          def constant
            @_constant ||= begin
              final_constant = parent_constant

              parts.each do |part|
                if final_constant.const_defined?(part, false)
                  final_constant = final_constant.const_get(part)
                else
                  new_module = Module.new
                  final_constant.const_set(part, new_module)
                  final_constant = new_module
                end
              end

              final_constant
            end
          end
        end
      end
    end
  end
end
