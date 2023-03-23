class BatchesController < ApplicationController
	before_action :authenticate_account!
	before_action :admin_account!
	before_action :set_batch, except: [:new, :create]

	def new
		@batch = current_user.batches.build
	end

	def create
		@batch = current_user.batches.build(batch_params)
		respond_to do |format|
			if @batch.save
				format.html { redirect_to account_path(current_account) }
				format.json { render json: @batch, status: :created }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @batch.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @batch.update(batch_params)
				format.html { redirect_to account_path(current_account) }
				format.json { render json: @batch, status: :ok }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @batch.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@batch.destroy!
		respond_to do |format|
			format.html { redirect_to account_path(current_account) }
			format.json { head :no_content }
		end
	end

	private

	def batch_params
		params.require(:batch).permit(:name, :status)
	end

	def set_batch
		@batch = Batch.find params[:id]
	rescue
		render file: "#{Rails.root}/public/404.html", layout: false
	end
end
