module Api
  module V1
    class SchemasController < ApplicationController

      before_action :authenticate_jwt!

      def index
      end

      def show
        @schema = Schema.find_by_uuid(params[:id])
        render nothing: true, status: :not_found unless guardian.can_view_schema?(@schema)
      end

      def create
        @schema = Schema.new(create_params)
        return render_validation_error(@schema) unless @schema.save
        render template: 'api/v1/schemas/show', status: :created
      end

      def destroy
        schema = Schema.find_by_uuid(params[:id])
        return render nothing: true, status: :not_found unless guardian.can_view_schema?(schema)

        schema.destroy!
        render nothing: true, status: :no_content
      end

      def edit
      end

      private

      def create_params
        params.fetch(:schema, {}).permit(:name)
      end
    end
  end
end
