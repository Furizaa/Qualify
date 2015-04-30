module Tenancy

  def create_tenant_schema(schema)
    NoBrainer.with_database(schema.account.database_name) do
      NoBrainer.table_create(schema.schema_name) unless NoBrainer.table_list.include?(schema.schema_name)
    end
  end

  def destroy_tenant_schema(schema)
    NoBrainer.with_database(schema.account.database_name) do
      NoBrainer.table_drop(schema.schema_name)
    end
  end

  def clean_tenant_databases_for(account)
    NoBrainer.db_drop(account.database_name) if account.schemas.length == 0
  end
end
