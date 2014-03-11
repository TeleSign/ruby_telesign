if defined? Rails
  Rails.logger.info '***************************'
  Rails.logger.info 'Starting fake telesign server'
  Rails.logger.info '***************************'
end

require 'mimic'
require 'json'
require 'securerandom'

class StdHelpers
  class << self
    def standard_headers
      # scraped from TeleSign api response
      { 'date'=>Time.now.strftime("%a, %d %b %Y %H:%M:%S %z"),
        'server'=>'Apache',
        'allow'=>'GET,POST,HEAD',
        'connection'=>'close',
        'content-type'=>'application/json'}
    end

    def std_response_body reference_id, status_code = 'UNKNOWN'
      # scraped from TeleSign api response
      { 'reference_id' => reference_id,
        'resource_uri' => "/v1/verify/#{reference_id}",
        'sub_resource' => "sms",
        'errors' => [],
        'status' => {
          'updated_on' => standard_updated_on,
          'code' => 290,
          'description' => 'Message in progress'
          },
        'verify' => {
          'code_state' => status_code,
          'code_entered' => ''
          }
        }
    end

    def std_reference_id
      SecureRandom.uuid.gsub('-','').upcase
    end

    def standard_updated_on
      Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%6N")
    end
  end
end

Mimic.mimic port: 11989, host: 'localhost', fork: false do
  # 'https://rest.telesign.com/v1/verify/sms'
  # params['phone_number']
  # params['language']
  # params['verify_code']
  # params['template']
  post '/v1/verify/sms' do
    http_status = 200
    headers = StdHelpers.standard_headers

    response_body = StdHelpers.std_response_body StdHelpers.std_reference_id

    content_type :json
    [http_status, headers, response_body.to_json]
  end

  # 'https://rest.telesign.com/v1/verify/call'
  # params['phone_number']
  # params['language']
  # params['verify_code']
  post '/v1/verify/call' do
    http_status = 200
    headers = StdHelpers.standard_headers
    response_body = StdHelpers.std_response_body StdHelpers.std_reference_id

    content_type :json
    [http_status, headers, response_body.to_json]
  end

  # "https://rest.telesign.com/v1/verify/%s" % @expected_ref_id
  # params[:reference_id]
  # params[:verify_code]
  get '/v1/verify/:reference_id' do
    http_status = 200
    headers = StdHelpers.standard_headers

    status_code = if params[:verify_code] =~ /666/
      'INVALID'
    else
      'VALID'
    end

    response_body = StdHelpers.std_response_body params[:reference_id], status_code

    content_type :json
    [http_status, headers, response_body.to_json]
  end

  # not using phoneid calls yet, but here are the stubs
  # # "https://rest.telesign.com/v1/phoneid/%s/%s"

  # # "/v1/phoneid/standard/%s" % phone_number
  # get '/v1/phoneid/standard/:phone_number' do

  # end

  # # /v1/phoneid/score/%s" % phone_number
  # get '/v1/phoneid/score/:phone_number' do

  # end

  # # /v1/phoneid/contact/%s" % phone_number
  # get '/v1/phoneid/contact/:phone_number' do

  # end

  # # /v1/phoneid/live/%s" % phone_number
  # get '/v1/phoneid/live/:phone_number' do

  # end
end
