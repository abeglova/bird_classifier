module ImageData
  require 'opencv'
  include OpenCV

  def self.extract(image_path)
    mat = OpenCV::CvMat.load(image_path)
    image = IplImage.new(mat.cols, mat.rows, mat.depth, mat.channel)
    mat.copy(image)

    image = image.BGR2GRAY.smooth(:blur, 3, 7)

    data_for_image = []
    data_for_image = get_hu_moments(image)
    [2, 4, 10].each do |slice_size|
      width = mat.cols / slice_size
      height = mat.rows / slice_size

      0.upto(slice_size - 1) do |x|
        0.upto(slice_size - 1) do |y|
          image.set_roi(CvRect.new(x * width, y * height, width, height))
          (data_for_image << get_hu_moments(image)).flatten!
        end
      end
    end

    data_for_image
  end

  def self.get_hu_moments(image)
    contours = image.canny(70, 150).find_contours(mode: OpenCV::CV_RETR_CCOMP,
      method: OpenCV::CV_CHAIN_APPROX_NONE)

    contour_image = image.clone.clear

    begin
      contour_image.draw_contours!(contours, CvColor::White, CvColor::White, 2, thickness: 2,
        line_type: :aa)

      return CvMoments.new(contour_image, true).hu.to_a
    rescue TypeError
      return [0, 0, 0, 0, 0, 0, 0]
    end
  end
  private_class_method :get_hu_moments
end
