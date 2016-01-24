module AcceptanceHelpers
  def json
    @json ||= if respond_to?(:response_body)
                JSON.parse(response_body, symbolize_names: true)
              else
                JSON.parse(response.body, symbolize_names: true)
              end
  end

  def sign_in_as(app)
    token = create(:auth_token, authenticable: app)
    header 'Authorization', "Token token=#{token.token}"
  end
end

RSpec.configure do |config|
  config.include AcceptanceHelpers, type: :acceptance
end
