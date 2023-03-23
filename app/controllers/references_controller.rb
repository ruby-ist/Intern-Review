class ReferencesController < ApplicationController

	before_action :not_an_intern_account!
	before_action :set_reference, except: [:create, :destroy]

	def create
		@section = Section.find params[:section_id]
		@reference = @section.references.build(reference_params)
		if @reference.save
			redirect_to @section, notice: "A new reference is added to the section"
		else
			@daily_reports = @section.daily_reports
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
		@reference = Reference.find params[:id]
		@reference.destroy!
		redirect_to section_path(@reference.section_id), notice: "Reference has been deleted for the section"
	end

	private

	def set_reference
		@reference = Reference.find params[:id]
		@section = @reference.section
		@daily_reports = @section.daily_reports
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end

	def reference_params
		params.require(:reference).permit(:url)
	end
end
