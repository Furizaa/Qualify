require 'tenancy'

module Api
  module V1
    class SchemasController < ApplicationController

      include Tenancy

      before_action :authenticate_jwt!

      def index
        @schemas = Schema.where(account_id: current_account.id)
      end

      def show
        @schema = Schema.find_by_uuid(params[:id])
        render nothing: true, status: :not_found unless guardian.can_view_schema?(@schema)
      end

      def create
        @schema = Schema.new(create_params)
        @schema.account = current_account
        return render_validation_error(@schema) unless @schema.save

        create_tenant_schema(@schema)
        render template: 'api/v1/schemas/show', status: :created
      end

      def destroy
        schema = Schema.find_by_uuid(params[:id])
        return render nothing: true, status: :not_found unless guardian.can_view_schema?(schema)

        destroy_tenant_schema(schema)
        schema.destroy!
        clean_tenant_databases_for(current_account)

        render nothing: true, status: :no_content
      end

      def update
        @schema = Schema.find_by_uuid(params[:id])
        return render nothing: true, status: :not_found unless guardian.can_view_schema?(@schema)

        @schema.name = params[:name] unless params[:name].nil?
        return render_validation_error(@schema) unless @schema.save

        render template: 'api/v1/schemas/show', status: :ok
      end

      private

      def create_params
        params.fetch(:schema, {}).permit(:name)
      end
    end
  end
end
