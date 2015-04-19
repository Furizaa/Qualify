class Document
  include NoBrainer::Document
  store_in database: ->{ "#{ Thread.current[:database] }" }, table: ->{ "#{ Thread.current[:table] }" }

  field :created_at, :type => Time

  before_create { self.created_at = Time.now }
end
