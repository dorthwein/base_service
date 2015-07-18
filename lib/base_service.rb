# module BaseService
# end

class BaseService
	# Create new record
	def self.create(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = service_model.new() if record.nil?
		object = apply_params(object: record, params: params)
		return validate_and_save(object)
	end



	def self.delete(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = service_model.find(params[:id]) if record.nil? && !params[:id].nil?
		record = service_model.find_by(params) if record.nil? && params[:id].nil?
		return validate_and_destroy(record)
	end



	def self.update(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = service_model.find(params[:id]) if record.nil?
		object = apply_params(object: record, params: params)
		return validate_and_save(object)
	end



	def self.validate_present_attributes(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = service_model.new() if record.nil?
		object = apply_params(object: record, params: params)

		if !object.valid?
			errors = object.errors.dup
			object.errors.clear
			params.each do |key, value|
				if errors[key].present?
					errors[key].each do |error|
						object.errors.add(key.to_sym, error)
					end
				end
			end

		end

		return object if object.errors == nil || object.errors.size == 0
		return {errors: object.errors.full_messages}
	end

	private

		# Clean params so that only model attributes remain
		def self.clean_params(object: nil, params: {})
			object = service_model if object.nil?
			clean_params = {}
			params.each do |key, value|
				clean_params[key] = params[key] if object.try((key + '?').to_sym)
			end
			return clean_params
		end

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
	        if object.destroy
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
