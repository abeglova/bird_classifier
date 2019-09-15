class TestSvmJob < ApplicationJob
  queue_as :default

  def perform
    Process::Svm.test(
      bird_test_data_file: BIRD_TEST_DATA_FILE,
      control_test_data_file: CONTROL_TEST_DATA_FILE
    )
  end
end
