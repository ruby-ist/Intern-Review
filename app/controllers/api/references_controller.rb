class Api::ReferencesController < Api::ApiController

	before_action :doorkeeper_authorize!
	before_action :not_an_intern_account!
	before_action :set_reference, except: :create
	before_action :set_section, only: :create

	def create
		@reference = @section.references.build(reference_params)
		if @reference.save
			render partial: "api/references/reference", locals: {reference: @reference}, status: :created
		else
			render json: {errors: @reference.errors}, status: :unprocessable_entity
		end
	end

	def update
		if @reference.update(reference_params)
			render partial: "api/references/reference", locals: {reference: @reference}, status: :ok
		else
			render json: {errors: @reference.errors}, status: :unprocessable_entity
		end
	end

	def destroy
		@reference.destroy!
		head :no_content
	end

	private

	def set_section
		@section = Section.find_by_id! params[:section_id].to_i
	rescue
		render json: { error: "Section not found!" }, status: :not_found
	end

	def set_reference
		@reference = Reference.find_by_id! params[:id].to_i
	rescue
		render json: { error: "Reference not found!" }, status: :not_found
	end

	def reference_params
		params.require(:reference).permit(:url)
	end
end
