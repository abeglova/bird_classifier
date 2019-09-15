class DemoController < ApplicationController
  def index
  end

  def results
    classifier = ::DemoClassifier.new
    classifier.image_files = params[:demo_form][:images]

    @results = classifier.classify
    @images = classifier.image_files
  end
end
