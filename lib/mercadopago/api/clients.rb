# frozen_string_literal: true

require 'mercadopago/base'

module MercadoPago
  module API
    class Clients < Base
      # Override parent class method
      # Place here main base URL
      def service_url
        'https://api.mercadopago.com'
      end

      # Argument must be an Hash
      # request.create_customer(email: 'example@mail.com')
      def create_customer(payload)
        response = connection.post(customer_endpoint, payload) do |req|
          req.params['access_token'] = access_token
        end
        response = process_response(response)
        OpenStruct.new(success?: true, body: response)
      rescue Faraday::ClientError => exception
        OpenStruct.new(success?: false, message: 'Los datos no son correctos', details: exception.response[:body].to_s)
      end

      # Argument must be an Hash
      def search_customers_by_email(email)
        response = connection.get(customers_search_endpoint, email: email) do |req|
          req.params['access_token'] = access_token
        end
        response = process_response(response)
        OpenStruct.new(success?: true, body: response)
      rescue Faraday::ClientError => exception
        OpenStruct.new(success?: false, message: 'Bad request', details: exception.response[:body].to_s)
      end

      def search_by(criteria={})
        response = connection.get(customers_search_endpoint, criteria) do |req|
          req.params['access_token'] = access_token
        end
        response = process_response(response)
        OpenStruct.new(success?: true, body: response)
      rescue Faraday::ClientError => exception
        OpenStruct.new(success?: false, message: 'Bad request', details: exception.response[:body].to_s)
      end

      def update_customer(customer_id, payload)
        response = connection.put(customer_id_endpoint(customer_id), payload) do |req|
          req.params['access_token'] = access_token
        end
        response = process_response(response)
        OpenStruct.new(success?: true, body: response)
      rescue Faraday::ClientError => exception
        OpenStruct.new(success?: false, message: 'Bad request', details: exception.response[:body].to_s)
      end

      def remove_customer(customer_id)
        response = connection.delete(customer_id_endpoint(customer_id)) do |req|
          req.params['access_token'] = access_token
        end
        response = process_response(response)
        OpenStruct.new(success?: true, body: response)
      rescue Faraday::ClientError => exception
        OpenStruct.new(success?: false, message: 'Bad request', details: exception.response[:body].to_s)
      end

      private

      def customer_id_endpoint(customer_id)
        "/v1/customers/#{customer_id}"
      end

      def customer_endpoint
        '/v1/customers'
      end

      def customers_search_endpoint
        '/v1/customers/search'
      end
    end
  end
end