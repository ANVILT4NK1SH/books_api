require 'rails_helper'

RSpec.describe "Books", type: :request do
 let(:expected_book_structure) do
  {
    "id"=> Integer,
    "title"=> String,
    "author"=> String,
    "read"=> [ TrueClass, FalseClass ]
  }
 end

 describe "Get /index" do
  before do
      create_list(:book, 10)
      get "/books"
      @body = JSON.parse(response.body)
    end

  it "returns books" do
    @body.each do |book|
      expect(book.keys).to contain_exactly(*expected_book_structure.keys)
    end
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end

  it "does not return empty if books exist" do
    expect(@body).not_to be_empty
  end

  it "returns 10 books" do
    expect(@body.size).to eq(10)
  end
 end

 describe "Get /show" do
  let (:book_id) { create(:book).id }

  before do
    get "/books/#{book_id}"
    @body = JSON.parse(response.body)
  end

  it 'checks for the correct structure' do
    expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
 end

 describe "POST /create" do
  before do
    post "/books", params: attributes_for(:book)
    @body = JSON.parse(response.body)
  end

  it 'checks the correct structure' do
    expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
  end

  it 'count of books should increase by 1' do
    expect(Book.count).to eq(1)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
 end

 describe "PUT /update" do
  let (:book_id) { create(:book, read: false).id }

  before do
    put "/books/#{book_id}", params: { title: 'updated title', author: 'updated author', read: true }
    @body = JSON.parse(response.body)
  end

  it 'checks for the correct structure' do
    expect(@body.keys).to contain_exactly(*expected_book_structure.keys)
  end

  it 'checks if the title is updated' do
    expect(Book.find(book_id).title).to eq('updated title')
  end

  it 'checks if the author is updated' do
    expect(Book.find(book_id).author).to eq('updated author')
  end

  it 'checks if read is updated' do
    expect(Book.find(book_id).read). to eq(true)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
 end

 describe "delete /destroy" do
  let (:book_id) { create(:book).id }

  before do
    delete "/books/#{book_id}"
  end

  it 'decrements the count of books by 1' do
    expect(Book.count).to eq(0)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
 end
end
