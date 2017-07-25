require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  # initialize test data
  let!(:product) { create :product }
  let(:product_id) { product.id }

  # Test suite for GET /api/v1/products
  describe 'GET /api/v1/products' do
    # make HTTP get request before each example
    before { get '/api/v1/products' }

    it 'returns products' do
      expect(json['products']).not_to be_empty
      expect(json['products'].size).to be > 0
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for /api/v1/products?page=2 (pagination)
  describe 'GET /api/v1/products?page=2' do
    let!(:product) { create_list :product, 20}
    before { get '/api/v1/products?page=2' }

    it 'returns second page 10 products' do
      expect(json['products']).not_to be_empty
      expect(json['products'].size).to eq 10
      expect(json['meta']['total_records']).to eq 20
      expect(json['meta']['total_pages']).to eq 2
      expect(json['meta']['current_page']).to eq 2
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/product/:id
  describe 'GET /api/v1/products/:id' do
    before { get "/api/v1/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json['product']).not_to be_empty
        expect(json['product']['id']).to eq(product_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:product_id) { "not_exist" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Resource not found/)
      end
    end
  end

  # Test suite for POST /api/v1/products
  describe 'POST /api/v1/products' do
    context 'when the request is valid' do
      let(:product) { build :product }
      let(:valid_attributes) { { product: { name: product.name, description: product.description, price: product.price } } }
      before { post '/api/v1/products', valid_attributes }

      it 'creates a product' do
        expect(Product.find_by(name: product.name)).not_to be_nil
      end

      it 'return a product' do
        expect(json['product']['name']).to eq(product.name)
        expect(json['product']['description']).to eq(product.description)
        expect(json['product']['price']).to eq(product.price.to_f)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/products', product: { name: 'Product name' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']['description']).to eq(["can't be blank"])
      end
    end
  end

  # Test suite for PUT /api/v1/products/:id
  describe 'PUT /api/v1/products/:id' do
    context 'when the record exists' do
      before { put "/api/v1/products/#{product_id}", product: { name: 'Updated name' } }

      it 'updates the record' do
        expect(response.body).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should update name' do
        expect(Product.find(product_id).name).to eq('Updated name')
      end
    end

    context 'when the record not exists' do
      before { put '/api/v1/products/not_exist', product: { name: 'Updated name' } }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  # Test suite for DELETE /products/:id
  describe 'DELETE /api/v1/products/:id' do
    context 'when the record exists' do
      before { delete "/api/v1/products/#{product_id}" }

      it 'delete record' do
        expect(Product.find_by(id: product_id)).to be_nil
      end
    end

    context 'when the record not exists' do
      before { delete '/api/v1/products/not_exist' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
