require 'rails_helper'
require 'tenancy'

RSpec.describe Tenancy do

  before do
    NoBrainer.db_drop('test') if NoBrainer.db_list.include?('test')
  end

  after :each do
    NoBrainer.db_list.each { |db| NoBrainer.db_drop(db) unless db == 'rethinkdb' }
  end

  let(:schema) { FactoryGirl::create(:schema) }
  let(:impl) { Class.new { include Tenancy } }

  it 'creates database and table' do
    impl.new.create_tenant_schema(schema)
    expect(NoBrainer.db_list).to include(schema.account.uuid)
    NoBrainer.with_database(schema.account.uuid) do
      expect(NoBrainer.table_list).to include(schema.uuid)
    end
    expect(NoBrainer.db_list.length).to be(2) # also counts system db "rethinkdb"
    NoBrainer.db_drop(schema.account.uuid)
  end

  it 'creates database and table only once' do
    impl.new.create_tenant_schema(schema)
    impl.new.create_tenant_schema(schema)
    expect(NoBrainer.db_list).to include(schema.account.uuid)
    NoBrainer.with_database(schema.account.uuid) do
      expect(NoBrainer.table_list.length).to be(1)
    end
    expect(NoBrainer.db_list.length).to be(2) # also counts system db "rethinkdb"
    NoBrainer.db_drop(schema.account.uuid)
  end

  it 'destroys table' do
    impl.new.create_tenant_schema(schema)
    impl.new.destroy_tenant_schema(schema)
    NoBrainer.with_database(schema.account.uuid) do
      expect(NoBrainer.table_list.length).to be(0)
    end
    expect(NoBrainer.db_list.length).to be(2) # also counts system db "rethinkdb"
    NoBrainer.db_drop(schema.account.uuid)
  end

  it 'destroys database' do
    impl.new.create_tenant_schema(schema)
    impl.new.destroy_tenant_schema(schema)

    account = schema.account
    account.schemas = []
    impl.new.clean_tenant_databases_for(account)
    expect(NoBrainer.db_list.length).to be(1) # also counts system db "rethinkdb"
  end
end
