class Api::BatchesController < ApplicationController
	before_action :authenticate_account!
	before_action :admin_account!
	before_action :set_batch, except: [:new, :create]

	def create
		@batch = current_user.batches.build(batch_params)

		if @batch.save
			render json: @batch, status: :created
		else
			render json: @batch.errors, status: :unprocessable_entity
		end
	end

	def update
		if @batch.update(batch_params)
			render json: @batch, status: :ok
		else
			render json: @batch.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@batch.destroy!
		head :no_content
	end

	private

	def batch_params
		params.require(:batch).permit(:name, :status)
	end

	def set_batch
		@batch = Batch.find params[:id]
	rescue
		render json: { error: "Batch not found" }, status: :not_found
	end
end
