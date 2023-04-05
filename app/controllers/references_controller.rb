class ReferencesController < ApplicationController

	before_action :not_an_intern_account!
	before_action :set_reference, except: [:create, :destroy]
	before_action :set_section, only: :create

	def create
		@reference = @section.references.build(reference_params)
		if @reference.save
			redirect_to @section, notice: "A new reference is added to the section"
		else
			@daily_reports = @section.daily_reports.order_by_date
			render "sections/show", status: :unprocessable_entity
		end
	end

	def edit
		render "sections/show"
	end

	def update
		if @reference.update(reference_params)
			redirect_to @section, notice: "Reference has been updated"
		else
			render 'sections/show', status: :unprocessable_entity
		end
	end

	def destroy
		@reference = Reference.find_by_id params[:id].to_i
		if @reference.present?
			@reference.destroy!
			redirect_to section_path(@reference.section_id), notice: "Reference has been deleted for the section"
		else
			redirect_back fallback_location: courses_path, alert: "Invalid Reference id"
		end
	end

	private

	def set_section
		@section = Section.find_by_id! params[:section_id].to_i
	rescue
		redirect_back fallback_location: courses_path, alert: "Invalid Section Id"
	end

	def set_reference
		@reference = Reference.find_by_id! params[:id].to_i
		@section = @reference.section
		@daily_reports = @section.daily_reports.order_by_date
	rescue
		redirect_back fallback_location: courses_path, alert: "Invalid reference Id"
	end

	def reference_params
		params.require(:reference).permit(:url)
	end
end
