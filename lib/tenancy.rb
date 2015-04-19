module Tenancy

  def create_tenant_schema(schema)
    NoBrainer.with_database(schema.account.uuid) do
      NoBrainer.table_create(schema.uuid) unless NoBrainer.table_list.include?(schema.uuid)
    end
  end

  def destroy_tenant_schema(schema)
    NoBrainer.with_database(schema.account.uuid) do
      NoBrainer.table_drop(schema.uuid)
    end
  end

  def clean_tenant_databases_for(account)
    NoBrainer.db_drop(account.uuid) if account.schemas.length == 0
  end
end
