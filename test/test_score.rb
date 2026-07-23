require 'test/unit'
require 'webmock/test_unit'
require 'telesign'

class TestScore < Test::Unit::TestCase

  DETECT_HOST = 'https://detect.telesign.com'

  def setup
    @customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
    @api_key = 'ABC12345yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
    @score_client = Telesign::ScoreClient.new(@customer_id, @api_key, rest_endpoint: DETECT_HOST)
  end

  def test_score_success
    phone_number = '11234567890'
    account_lifecycle_event = 'create'

    stub_request(:post, "#{DETECT_HOST}/intelligence/phone")
      .with(
        body: hash_including({
          'phone_number' => phone_number,
          'account_lifecycle_event' => account_lifecycle_event
        }),
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      )
      .to_return(
        status: 200,
        body: '{"risk": {"level": "low", "recommendation": "allow"}}',
        headers: { 'Content-Type' => 'application/json' }
      )

    puts Telesign::ScoreClient.instance_method(:score).source_location  
    response = @score_client.score(phone_number, account_lifecycle_event)
    
    puts "Response status code: #{response.status_code}"
    puts "Response headers: #{response.headers}"
    puts "Response body: #{response.body}"
    puts "Parsed JSON response: #{response.json}"

    assert response.ok
    assert_equal 'low', response.json['risk']['level']
    assert_equal 'allow', response.json['risk']['recommendation']
  end

  def test_score_phone_number_validation
    assert_raise(ArgumentError) { @score_client.score(nil, 'create') }
    assert_raise(ArgumentError) { @score_client.score('', 'create') }
  end

  def test_score_account_lifecycle_event_validation
    assert_raise(ArgumentError) { @score_client.score('phone_number', nil) }
    assert_raise(ArgumentError) { @score_client.score('phone_number', '') }
  end

  def test_email_intelligence_success
    email_address = 'USER@Example.COM'
    account_lifecycle_event = 'CREATE'

    stub_request(:post, "#{DETECT_HOST}/intelligence/email")
      .with(
        body: hash_including({
          'email_address' => 'user@example.com',
          'account_lifecycle_event' => 'create'
        }),
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      )
      .to_return(
        status: 200,
        body: '{"risk": {"level": "medium", "recommendation": "review"}}',
        headers: { 'Content-Type' => 'application/json' }
      )

    response = @score_client.email_intelligence(email_address, account_lifecycle_event)

    assert response.ok
    assert_equal 'medium', response.json['risk']['level']
    assert_equal 'review', response.json['risk']['recommendation']
  end

  def test_email_intelligence_validation
    assert_raise(ArgumentError) { @score_client.email_intelligence(nil, 'create') }
    assert_raise(ArgumentError) { @score_client.email_intelligence('user@example.com', nil) }
    assert_raise(ArgumentError) { @score_client.email_intelligence('', '') }
  end
end
  