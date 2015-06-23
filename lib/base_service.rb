# module BaseService
# end

class BaseService
	# Create new record
	def self.create(record: nil, params: {})
		record = service_model.new() if record.nil?
		object = apply_params(object: record, params: params)
		return validate_and_save(object)
	end



	def self.delete(record: nil, params: {})
		record = service_model.find(params[:id]) if record.nil?
		return validate_and_destroy(record)
	end



	def self.update(record: nil, params: {})		
		record = service_model.find(params[:id]) if record.nil?
		object = apply_params(object: record, params: params)
		return validate_and_save(object)
	end

	def self.validate(record: nil, params: {})		
		print "FUCK YEAH!!"
	end

	private

		# Applies attributes to record if present
		def self.apply_params(object: nil, params: {})
			object.fields.each do |field|
				object.write_attribute(field[0].to_sym, params[field[0].to_sym]) if params[field[0].to_sym].present? || params[field[0].to_sym] == false
			end
			return object
		end


		# Validates & Saves Record - if invalid, returns Errors
		def self.validate_and_save(object)
	        if object.valid?
	        	object.save!
				return object
	        else 
	            return {errors: object.errors.full_messages}
	        end
		end


		# Validates & Destroys Record - if destroy fails, returns Errors
		def self.validate_and_destroy(object)			
	        if object.destroy!
	            return {}
	        else 
	            return {errors: object.errors.full_messages}
	        end
		end


		# Gives model constant matching Service Name - i.e. UserService returns User (klass)
		def self.service_model
			return self.to_s.reverse.sub('Service'.reverse, '').reverse.constantize
		end

end






