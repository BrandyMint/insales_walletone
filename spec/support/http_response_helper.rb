module HttpResponseHelper
  def response_from_file(path)
    File.read("#{responses_path}/#{path}")
  end

private

  def responses_path
    "#{::Rails.root}/spec/support/http_responses"
  end
end
