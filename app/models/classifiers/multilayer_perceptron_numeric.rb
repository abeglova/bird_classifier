require 'ai4r/classifiers/multilayer_perceptron'
#Ai4r::Classifiers::MultilayerPerceptron assumes discrete inputs. This modifies the code to allow for numeric inputs

module Classifiers
  class MultilayerPerceptronNumeric < Ai4r::Classifiers::MultilayerPerceptron

    def build(data_set)
      data_set.check_not_empty
      @data_set = data_set
      @domains = @data_set.build_domains.collect {|domain| domain.to_a}
      @outputs = @domains.last.length
      @inputs = @domains.length - 1
      @structure = [@inputs] + @hidden_layers + [@outputs]
      @network = @network_class.new @structure
      @training_iterations.times do
        data_set.data_items.each do |data_item|
          input_values = data_item[0...-1]
          output_values = data_to_output(data_item.last)
          @network.train(input_values, output_values)
        end
      end
      return self
    end

    def eval(data)
      input_values = data #data_to_input(data)
      output_values = @network.eval(input_values)
      return @domains.last[get_max_index(output_values)]
    end
  end
end
