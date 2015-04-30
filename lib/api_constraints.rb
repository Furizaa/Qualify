class ApiConstraints
  def initialize(options)
    @version = options[:version]
  end

  def matches?(request)
    request.headers['Accept'].include?("application/vnd.qualify.v#{@version}+json")
  end
end
