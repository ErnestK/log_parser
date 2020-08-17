# frozen_string_literal: true

module Services
  module Parsers
    # Class for parsing documents with extension .log and row which consisit from 2 elements: endpoint and ip
    # Example: "/help_page/1 192.128.0.12"
    class FileLog
      include Dry::Monads[:result]

      COUNT_ELEMENT_IN_ROW = 2

      def call(row)
        split_row(row).bind do |endpoint, ip|
          validate_endpoint(endpoint).bind do
            validate_ip(ip).bind do
              Success([endpoint, ip])
            end
          end
        end
      end

      private

      def validate_endpoint(endpoint)
        if endpoint.match?(%r{^/[\w|/]+$})
          Success(true)
        else
          Failure("Invalid endoint data: #{endpoint}")
        end
      end

      def validate_ip(ip)
        return Success(true) if ENV['VALIDATE_IP'] == 'false'

        is_match_ip_template = (ip =~ Resolv::IPv4::Regex) || (ip =~ Resolv::IPv6::Regex) ? true : false
        if is_match_ip_template
          Success(true)
        else
          Failure("Invalid ip: #{ip}")
        end
      end

      def split_row(row)
        if row.split(' ').size == COUNT_ELEMENT_IN_ROW
          Success(row.split(' '))
        else
          Failure("Should have 2 elements delimiter by space, invalid row: #{row}")
        end
      rescue NoMethodError => e
        Failure("NoMethodError on element #{row}, during read file: #{e.message}")
      rescue ex
        Failure("Exception, during read file: #{ex.message}")
      end
    end
  end
end
