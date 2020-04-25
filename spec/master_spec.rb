require 'rails_helper'

RSpec.describe '管理者画面のテスト', type: :feature do
	let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }
	let!(:cake) { Genre.create(name: "ケーキ", is_active: true) }
	let!(:pudding) { Genre.create(name: "プリン", is_active: true) }
	before do
		visit new_admin_session_path
		fill_in 'admin[email]', with: admin.email
		fill_in 'admin[password]', with: admin.password
		click_button 'ログイン'
	end

	it 'トップ画面が表示される' do
		expect(page).to have_content '本日の注文件数'
	end

	it 'ジャンル一覧画面が表示される' do
		genre_link = find_all('a')[4].native.inner_text
		click_link genre_link
		expect(page).to have_content 'ジャンル追加・一覧画面'
	end

	it '追加したジャンルが表示されている' do
		visit admin_genres_path
		fill_in 'genre[name]', with: 'グミ'
		choose 'genre_is_active_true'
		click_button '追加'
		expect(page).to have_content 'グミ'
	end

	it '商品一覧画面が表示される' do
		product_index_link = find_all('a')[1].native.inner_text
		click_link product_index_link
		expect(page).to have_content '商品一覧'
	end

	it '商品新規登録画面が表示される' do
		visit admin_products_path
		new_product_link = find_all('a')[6].native.inner_text
		click_link new_product_link
		expect(page).to have_content '商品登録'
	end

	it '必要事項を入力して商品一覧画面に遷移する' do
		visit new_admin_product_path
		fill_in 'product[product_name]', with: 'シフォンケーキ'
		fill_in 'product[product_description]', with: 'おいしいシフォンケーキです'
		select "ケーキ", from: 'product_genre_id'
		fill_in 'product[tax_included_price]', with: 500
		select '販売中', from: 'product_sale_status'
		click_button '新規登録'
		expect(page).to have_content '商品一覧'
		expect(page).to have_content 'シフォンケーキ'
	end

	it '商品新規登録画面が表示される(2品目)' do
		visit admin_products_path
		new_product_link = find_all('a')[6].native.inner_text
		click_link new_product_link
		expect(page).to have_content '商品登録'
	end

	it '必要事項を入力して商品一覧画面に遷移する(2品目)' do
		visit new_admin_product_path
		fill_in 'product[product_name]', with: 'プッチンプリン'
		fill_in 'product[product_description]', with: 'おいしいプッチンプリンです'
		select "プリン", from: 'product_genre_id'
		fill_in 'product[tax_included_price]', with: 300
		select '販売中', from: 'product_sale_status'
		click_button '新規登録'
		expect(page).to have_content '商品一覧'
		expect(page).to have_content 'プッチンプリン'
	end

	it 'ログアウトリンクを押すとログイン画面に遷移する' do
		logout_link = find_all('a')[5].native.inner_text
		click_link logout_link
		expect(current_path).to eq(new_admin_session_path)
	end
end


# ここから④
# let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }
# let(:customer1) { Customer.create(email: "customer1.example.com",
# 								  password: "customer1",
# 								  surname: "有田",
# 								  name: "哲平",
# 							      kana_surname: "アリタ",
# 								  kana_name: "テッペイ",
# 								  postal_code: "7777777",
# 								  address: "東京都世田谷区",
# 							      phone_number: "7777777777",
# 								  account_status: true)}
# 	before do
# 		visit new_admin_session_path
# 		fill_in 'admin[email]', with: admin.email
# 		fill_in 'admin[password]', with: admin.password
# 		click_button 'ログイン'
# 	end

# 	it 'トップ画面が表示される' do
# 		expect(page).to have_content '本日の注文件数'
# 	end

# 	it '会員一覧画面が表示される' do
# 		customer_index_link = find_all('a')[1].native.inner_text
# 		click_link customer_index_link
# 		expect(current_path).to eq(admin_customers_path)
# 		expect(page).to have_content have_no_content customer1.surname
# 	end

