class DemoController < ApplicationController
  def new; end

  def results
    classifier = ::Demo.new(params[:demo_form][:classifier])
    classifier.image_files = params[:demo_form][:images]

    if classifier.valid?
      @results = classifier.classify
      @images = classifier.image_files
    else
      flash.now[:error] = classifier.errors.full_messages.to_sentence
      render :new
    end
  end
end
