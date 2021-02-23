class FetchDollarService < BusinessProcess::Base
  URL = 'https://economia.awesomeapi.com.br/json/all/USD-BRL'

  steps :index

  def call
    process_steps
    @brl
  end

  def index
    @brl = RestClient.get(URL)
  end
end
