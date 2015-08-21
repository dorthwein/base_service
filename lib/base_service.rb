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
		record = set_record(record: record, params: params)

		return validate_and_destroy(record)
	end



	def self.update(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = set_record(record: record, params: params)

		object = apply_params(object: record, params: params)
		return validate_and_save(object)
	end



	def self.validate_present_attributes(record: nil, params: {})
		params = clean_params(object: record, params: params)
		record = service_model.new() if record.nil? # Note - not using set_record intentially
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

	# private

	# Clean params so that only model attributes remain
	def self.clean_params(object: nil, params: {})
		object = service_model.new() if object.nil?
		clean_params = {}
#			clean_params[:id] = params[:id] if !params[:id].nil?
		params.each do |key, value|
			clean_params[key.to_sym] = params[key] if object.respond_to?(key.to_s + '=') && key != 'id' && key != :id
		end
		return clean_params
	end

	# Common method to initialize record
	def self.set_record(record: nil, params: {})
		# If record already set skip setting...
		return record if !record.nil?

		# If ID present, find_by id
		return service_model.find(params[:id]) if params[:id].present?

		# If param keys present, find_by params
		record = service_model.find_by(params) if params.keys.any? rescue nil

		# If no params, return new instace
		record = service_model.new() if record.nil?
		return record
	end
	# Applies attributes to record if present
	def self.apply_params(object: nil, params: {})
		params.each do |key, value|
			setter = key.to_s + '='
			object.send(setter, value) if object.respond_to?(setter)
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
