class BatchesController < ApplicationController
	before_action :authenticate_account!
	before_action :admin_account!
	before_action :set_batch, except: [:new, :create]

	def new
		@batch = current_user.batches.build
	end

	def create
		@batch = current_user.batches.build(batch_params)
		if @batch.save
			redirect_to account_path(current_account), notice: "A new batch created!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
	end

	def update
		if @batch.update(batch_params)
			redirect_to account_path(current_account), notice: "Batch has been updated"
		else
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@batch.destroy!
		redirect_to account_path(current_account), notice: "Batch has been deleted"
	end

	private

	def batch_params
		params.require(:batch).permit(:name, :status)
	end

	def set_batch
		@batch = Batch.find_by_id! params[:id].to_i
	rescue
		redirect_back fallback_location: account_path(current_account), alert: "Invalid batch Id"
	end
end
