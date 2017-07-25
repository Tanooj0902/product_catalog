class Api::V1::ProductSerializer < Api::V1::ApplicationSerializer
  attributes :id, :name, :description, :price, :price_currency_symbol, :price_currency_code

  def price
    object.price.to_f
  end

  def price_currency_symbol
    object.price.currency.symbol
  end

  def price_currency_code
    object.price.currency.iso_code
  end
end
