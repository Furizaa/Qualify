require 'simplecov'

SimpleCov.start do
  add_group 'Models', '/app/models/'
  add_group 'Controllers', '/app/controllers/'
  add_group 'Views', '/app/views/'
  add_group 'Helpers', '/app/helpers/'

  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/db/'

  project_name 'Qualify'

  # Set special coverage dir if we are running on circle ci
  # https://circleci.com/docs/code-coverage
  if ENV['CIRCLE_ARTIFACTS']
    dir = File.join('..', '..', '..', ENV['CIRCLE_ARTIFACTS'], "coverage")
    coverage_dir(dir)
  elsif
    coverage_dir '.coverage'
  end
end