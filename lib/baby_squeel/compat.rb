module BabySqueel
  module Compat
    def self.enable!
      ::ActiveRecord::Base.singleton_class.prepend QueryMethods
      ::ActiveRecord::Relation.prepend QueryMethods
    end

    module QueryMethods
      def joins(*args, &block)
        if block_given? && args.empty?
          joining(&block)
        else
          super
        end
      end

      # Heads up, Array#select conflicts with
      # ActiveRecord::QueryMethods#select. So, if arity
      # is given to the block, we'll use Array#select.
      # Otherwise, you'll be in a DSL block.
      #
      #    Model.select { This is DSL }
      #    Model.select { |m| This is not DSL }
      #
      def select(*args, &block)
        if block_given? && args.empty? && block.arity.zero?
          selecting(&block)
        else
          super
        end
      end

      def order(*args, &block)
        if block_given? && args.empty?
          ordering(&block)
        else
          super
        end
      end

      def group(*args, &block)
        if block_given? && args.empty?
          grouping(&block)
        else
          super
        end
      end

      def having(*args, &block)
        if block_given? && args.empty?
          when_having(&block)
        else
          super
        end
      end

      def where(*args, &block)
        if block_given? && args.empty?
          super DSL.evaluate(self, &block)
        else
          super
        end
      end
    end
  end
end
