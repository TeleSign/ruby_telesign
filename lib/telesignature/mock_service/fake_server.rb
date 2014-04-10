if defined? Rails
  Rails.logger.info '***************************'
  Rails.logger.info 'Starting fake telesign server'
  Rails.logger.info '***************************'
end

require 'mimic'
require 'json'
require 'securerandom'

Mimic.mimic port: (ENV['TELESIGN_PORT'].to_i || 11989), host: (ENV['TELESIGN_URL'] || 'localhost'), fork: false do
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

  # 'https://rest.telesign.com/v1/verify/%s' % @expected_ref_id
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
  # # 'https://rest.telesign.com/v1/phoneid/%s/%s'

  # '/v1/phoneid/standard/%s' % phone_number
  get '/v1/phoneid/standard/:phone_number' do
    http_status = 200
    headers = StdHelpers.standard_headers

    phone_type_hash = if params[:phone_number] =~ /111/
      {'code' =>'1', 'description' =>'FIXED'}
    elsif params[:phone_number] =~ /222/
      {'code' =>'2', 'description' =>'MOBILE'}
    elsif params[:phone_number] =~ /333/
      {'code' =>'3', 'description' =>'PREPAID'}
    elsif params[:phone_number] =~ /444/
      {'code' =>'4', 'description' =>'TOLLFREE'}
    elsif params[:phone_number] =~ /555/ # this could be problematic
      {'code' =>'5', 'description' =>'VOIP'}
    elsif params[:phone_number] =~ /666/
      {'code' =>'6', 'description' =>'PAGER'}
    elsif params[:phone_number] =~ /777/
      {'code' =>'7', 'description' =>'PAYPHONE'}
    elsif params[:phone_number] =~ /888/
      {'code' =>'8', 'description' =>'INVALID'}
    elsif params[:phone_number] =~ /999/
      {'code' =>'9', 'description' =>'RESTRICTED'}
    elsif params[:phone_number] =~ /101010/
      {'code' =>'10', 'description' =>'PERSONAL'}
    elsif params[:phone_number] =~ /110110/
      {'code' =>'11', 'description' =>'VOICEMAIL'}
    else
      {'code' =>'20', 'description' =>'OTHER'}
    end

    response_body = StdHelpers.std_standard_body params[:phone_number], phone_type_hash

    content_type :json
    [http_status, headers, response_body.to_json]
  end

  # # /v1/phoneid/score/%s' % phone_number
  # get '/v1/phoneid/score/:phone_number' do

  # end

  # # /v1/phoneid/contact/%s' % phone_number
  # get '/v1/phoneid/contact/:phone_number' do

  # end

  # # /v1/phoneid/live/%s' % phone_number
  # get '/v1/phoneid/live/:phone_number' do

  # end
end

BEGIN {
  class StdHelpers
    class << self
      def standard_headers
        # scraped from TeleSign api response
        { 'date' =>Time.now.strftime('%a, %d %b %Y %H:%M:%S %z'),
          'server' =>'Apache',
          'allow' =>'GET,POST,HEAD',
          'connection' =>'close',
          'content-type' =>'application/json'}
      end

      def std_response_body reference_id, status_code = 'UNKNOWN'
        # scraped from TeleSign api response
        { 'reference_id' => reference_id,
          'resource_uri' => '/v1/verify/#{reference_id}',
          'sub_resource' => 'sms',
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

      def std_standard_body phone_number, phone_type_hash
        simple_phone = phone_number[0]=='1' ? phone_number.slice(1..-1) : phone_number
        { 'reference_id' => std_reference_id,
          'resource_uri' => nil,
          'sub_resource' => 'standard',
          'status' => {
            'updated_on' => standard_updated_on,
            'code' => 300,
            'description' => 'Transaction successfully completed'
            },
          'errors' => [],
          'location' => {
            'city' => 'Reno',
            'state' => 'NV',
            'zip' => '89501',
            'metro_code' => '6720',
            'county' => '',
            'country' => {
              'name' => 'United States',
              'iso2' => 'US',
              'iso3' => 'USA'
              },
            'coordinates' => {
              'latitude' => 39.52598,
              'longitude' => -119.80796
              },
            'time_zone' => {
              'name' =>' America/Los_Angeles',
              'utc_offset_min' => '-8',
              'utc_offset_max' => '-8'
              }
            },
          'numbering' => {
            'original' => {
              'complete_phone_number' => '1'+simple_phone,
              'country_code' => '1',
              'phone_number' => simple_phone
              },
            'cleansing' => {
              'call' => {
                'country_code' => '1',
                'phone_number' => simple_phone,
                'cleansed_code' => 100,
                'min_length' => 10,
                'max_length' => 10},
                'sms' => {
                  'country_code' => '1',
                  'phone_number' => simple_phone,
                  'cleansed_code' => 100,
                  'min_length' => 10,
                  'max_length' => 10
                  }
                }
              },
          'phone_type' => phone_type_hash,
          'carrier' => {
            'name' => 'AT&T - PSTN'
          }
        }
      end

      def std_reference_id
        SecureRandom.uuid.gsub('-','').upcase
      end

      def standard_updated_on
        Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%6N')
      end
    end
  end
}
