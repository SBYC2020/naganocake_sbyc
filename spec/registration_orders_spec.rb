require 'rails_helper'

RSpec.describe '会員側のテスト', type: :feature do
	describe '新規登録のテスト' do
		it '新規登録画面が表示される' do
			visit root_path
			signup_link = find_all('a')[2].native.inner_text
			click_link signup_link
			expect(current_path).to eq(new_customer_registration_path)
		end
		it '新規登録するとトップ画面に遷移しヘッダーが変わる' do
			visit new_customer_registration_path
			fill_in 'customer[surname]', with: '希志'
			fill_in 'customer[name]', with: 'あいの'
			fill_in 'customer[kana_surname]', with: 'キシ'
			fill_in 'customer[kana_name]', with: 'アイノ'
			fill_in 'customer[password]', with: 'kishiaino'
			fill_in 'customer[email]', with: "kishiaino@example.com"
			fill_in 'customer[postal_code]', with: "0000000"
			fill_in 'customer[address]', with: '東京都港区'
			fill_in 'customer[phone_number]', with: '0000000000'
			fill_in 'customer[password_confirmation]', with: 'kishiaino'
			click_button '新規登録'
			expect(current_path).to eq '/'
			expect(page).to have_link 'マイページ', href: customer_path
		end
	end
	describe '会員登録後のテスト' do
		let!(:customer1) { Customer.create(email: "kasuga@example.com",
										password: "kasugakasuga",
										surname: "春日",
										name: "俊彰",
										kana_surname: "カスガ",
										kana_name: "トシアキ",
										postal_code: "1234567",
										address: "埼玉県所沢市",
										phone_number: "1234567890",
										account_status: true) }
		let!(:genre1) { Genre.create(name: "ケーキ", is_active: true) }
		let!(:product1) { Product.create(product_name: "ショートケーキ",
										product_description: "おいしいおいしいショートケーキです。",
										genre_id: 1,
										sale_status: true,
										tax_included_price: 500) }
		let!(:shipping_address1) { ShippingAddress.create(customer_id: 1,
										address_name: "佐藤満春",
										postal_code: "1234567",
										address: "東京都町田市") }
		let(:order1) { Order.find(1) }
		before do
			visit new_customer_session_path
			fill_in 'customer[email]', with: customer1.email
			fill_in 'customer[password]', with: customer1.password
			click_button 'ログイン'
		end
		context 'トップ画面〜商品詳細画面のテスト' do
			it 'おすすめ商品の画像を押すと該当画像の詳細画面へ遷移する' do
				# 画像のalt属性を利用してリンクをクリックする
				click_on product1.product_name
				expect(current_path).to eq('/products/' + product1.id.to_s)
			end
			it '詳細画面に該当商品の情報が正しく表示されている' do
				click_on product1.product_name
				expect(page).to have_content product1.product_name
				expect(page).to have_content product1.product_description
				expect(page).to have_content product1.genre.name
				expect(page).to have_content product1.tax_included_price
			end
		end
		context '商品詳細画面〜カート画面のテスト' do
			before do
				click_on product1.product_name
				select 3, from: 'cart_quantity'
				click_button 'カートに入れる'
			end
			it 'カート画面に遷移する' do
				expect(current_path).to eq(carts_path)
			end
			it 'カートの中身が正しく表示されている' do
				expect(page).to have_content product1.product_name
				expect(find_field('cart[quantity]').value).to eq 3.to_s
			end
			it '商品の個数を変更し更新ボタンを押すと合計表示が正しく表示される' do
				fill_in 'cart[quantity]', with: 5
				expect(page).to have_content 2,500
			end
			it '買い物を続けるボタンを押すとトップ画面に遷移する' do
				click_on '買い物を続ける'
				expect(current_path).to eq(root_path)
			end
			it '情報入力に進むボタンを押すと情報入力画面に遷移する' do
				click_on '情報入力に進む'
				expect(current_path).to eq(new_order_path)
			end
		end
		context '情報入力画面のテスト' do
			before do
				click_on product1.product_name
				select 3, from: 'cart_quantity'
				click_button 'カートに入れる'
				click_on '情報入力に進む'
				choose 'order_payment_method_クレジットカード'
				choose 'address_info_shipping_address_info'
				select "1234567 東京都町田市 佐藤満春" , from: 'address'
				click_button '注文確認画面へ'
			end
			it '注文確認画面に遷移する' do
				expect(current_path).to eq(order_confirm_path)
				expect(page).to have_content "クレジットカード"
				expect(page).to have_content 1,800
				expect(page).to have_content product1.product_name
			end
			it 'サンクスページに遷移する' do
				click_on '購入確定'
				expect(current_path).to eq(order_finish_path)
			end
			it 'サンクスページからマイページに遷移する' do
				click_on '購入確定'
				click_on 'マイページ'
				expect(current_path).to eq(customer_path)
			end
			it 'マイページから注文一覧画面に遷移する' do
				click_on '購入確定'
				click_on 'マイページ'
				click_link '一覧を見る', href: '/orders'
				expect(current_path).to eq(orders_path)
			end
			it '注文詳細画面が表示される' do
				click_on '購入確定'
				click_on 'マイページ'
				click_link '一覧を見る', href: '/orders'
				click_link '表示する', href: '/orders/1'
				expect(current_path).to eq '/orders/1'
			end
			it '注文詳細画面のデータが正しく表示されている' do
				click_on '購入確定'
				click_on 'マイページ'
				click_link '一覧を見る', href: '/orders'
				click_link '表示する', href: '/orders/1'
				expect(page).to have_content product1.product_name
				expect(page).to have_content "東京都町田市"
				expect(order1.order_status).to eq "入金待ち"
			end
		end
	end
end