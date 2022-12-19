module DeviseAuth
  module Utils
    class << self
      def load_json_file(file_path)
        file = File.open(Rails.root.join(file_path), 'r').read
        JSON.parse(file).deep_symbolize_keys
      end

      def validate(hash, required_keys)
        required_keys.select do |key|
          if key.is_a?(Array)
            hash.slice(*key).empty?
          else
            hash[key].nil?
          end
        end
      end

      def build_error_message(missing_keys)
        error_message = missing_keys.map do |key|
          key.is_a?(Array) ? key.join(' or ') : key
        end
        "Missing keys: #{error_message.join(', ')}"
      end

      def deep_slice(hash, keys)
        return unless hash.is_a?(Hash)

        keys.each_with_object({}) do |k, new_hash|
          if k.is_a?(Hash)
            k.each do |sub_key, sub_value|
              new_hash[sub_key] = deep_slice(hash[sub_key], sub_value) if hash.key?(sub_key)
            end
          else
            new_hash[k] = hash[k] if hash.key?(k)
          end
          new_hash
        end
      end
    end
  end
end
