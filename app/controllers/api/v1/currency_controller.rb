class Api::V1::CurrencyController < Api::ApiController
  def show
    dollar = FetchDollarService.call(nil)

    render_success dollar.result
  end
end
