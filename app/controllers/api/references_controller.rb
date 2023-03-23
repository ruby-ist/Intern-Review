class Api::ReferencesController < Api::ApiController

	before_action :not_an_intern_account!
	before_action :set_reference, except: [:create, :destroy]

	def create
		@section = Section.find params[:section_id]
		@reference = @section.references.build(reference_params)
		if @reference.save
			render json: @reference, status: :created
		else
			@daily_reports = @section.daily_reports
			render @reference.errors, status: :unprocessable_entity
		end

	end

	def update
		if @reference.update(reference_params)
			render json: @reference, status: :ok
		else
			render @reference.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@reference = Reference.find params[:id]
		@reference.destroy!
		head :no_content
	end

	private

	def set_reference
		@reference = Reference.find params[:id]
		@section = @reference.section
		@daily_reports = @section.daily_reports
	rescue
		render json: { error: "Reference not found!" }, status: :not_found
	end

	def reference_params
		params.require(:reference).permit(:url)
	end
end
