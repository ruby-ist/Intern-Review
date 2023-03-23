class ReferencesController < ApplicationController

	before_action :not_an_intern_account!
	before_action :set_reference, except: [:create, :destroy]

	def create
		@section = Section.find params[:section_id]
		@reference = @section.references.build(reference_params)
		respond_to do |format|
			if @reference.save
				format.html { redirect_to @section }
				format.json { render json: @reference, status: :created }
			else
				@daily_reports = @section.daily_reports
				format.html { render "sections/show", status: :unprocessable_entity }
				format.json { render @reference.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		render "sections/show"
	end

	def update
		respond_to do |format|
			if @reference.update(reference_params)
				format.html{ redirect_to @section }
				format.json { render json: @reference, status: :ok }
			else
				format.html { render 'sections/show', status: :unprocessable_entity }
				format.json { render @reference.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@reference = Reference.find params[:id]
		@reference.destroy!
		respond_to do |format|
			format.html { redirect_to section_path(@reference.section_id) }
			format.json { head :no_content }
		end
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
