require 'rails_helper'

RSpec.describe Demo do
  let(:image_file) { File.join(Rails.root, '/spec/fixtures/test_image.jpg') }

  context 'classify' do
    context 'when the selected classifier_type is neural net' do
      it 'evaluates Classifiers::NeuralNet.make_prediction for the image' do
        expect(::ImageData).to receive(:extract).and_return([1, 2, 3])
        expect(Classifiers::NeuralNet).to receive(:make_prediction).with([1.0, 2.0, 3.0]).
          and_return(false)

        demo = Demo.new('neural net')
        demo.image_files = [Rack::Test::UploadedFile.new(File.open(image_file))]
        result = demo.classify
        expect(result).to eq([false])
      end
    end

    context 'when the selected classifier_type is svm' do
      it 'evaluates Classifiers::Svm.make_prediction for the image' do
        expect(::ImageData).to receive(:extract).and_return([1, 2, 3])
        expect(Classifiers::Svm).to receive(:make_prediction).with([1.0, 2.0, 3.0]).
          and_return(false)

        demo = Demo.new('svm')
        demo.image_files = [Rack::Test::UploadedFile.new(File.open(image_file))]
        result = demo.classify
        expect(result).to eq([false])
      end
    end
  end
end
