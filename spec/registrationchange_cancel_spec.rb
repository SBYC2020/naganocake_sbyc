require 'rails_helper'

RSpec.describe '登録情報変更のテスト', type: :feature do
	let!(:customer1) { Customer.create(email: "kasuga@example.com",
										password: "kasugakasuga",
										surname: "春日",
										name: "俊彰",
										kana_surname: "カスガ",
										kana_name: "トシアキ",
										postal_code: "1234567",
										address: "埼玉県所沢市",
										phone_number: "1234567890",
										account_status: true)}
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
	let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }
	before do
		visit new_customer_session_path
		fill_in 'customer[email]', with: customer1.email
		fill_in 'customer[password]', with: customer1.password
		click_button 'ログイン'
	end
	context '会員情報編集画面のテスト' do
		before do
			visit customer_path
			click_on '編集する'
		end
		it '会員情報編集画面に遷移する' do
			expect(current_path).to eq(edit_customer_path)
		end
		it '登録情報を変更できる' do
			fill_in 'customer[surname]', with: '有田'
			fill_in 'customer[name]', with: '哲平'
			fill_in 'customer[kana_surname]', with: 'アリタ'
			fill_in 'customer[kana_name]', with: 'テッペイ'
			fill_in 'customer[email]', with: "arita@example.com"
			fill_in 'customer[postal_code]', with: '9999999'
			fill_in 'customer[address]', with: '東京都港区'
			fill_in 'customer[phone_number]', with: '1234567890'
			click_on '編集内容を保存する'
			expect(current_path).to eq(customer_path)
			expect(page).to have_content '有田'
			expect(page).to have_content '哲平'
			expect(page).to have_content 'arita@example.com'
			expect(page).to have_content '9999999'
			expect(page).to have_content '東京都港区'
			expect(page).to have_content '1234567890'
		end
	end
	context '配送先画面のテスト' do
		before do
			visit customer_path
			click_link '一覧を見る', href: '/shipping_addresses'
		end
		it '配送先一覧画面が表示される' do
			expect(current_path).to eq(shipping_addresses_path)
		end
		it '配送先を登録すると一覧に表示される' do
			fill_in 'shipping_address[postal_code]', with: '1111111'
			fill_in 'shipping_address[address]', with: '東京都港区'
			fill_in 'shipping_address[address_name]', with: '上田晋也'
			click_button '登録する'
			expect(current_path).to eq(shipping_addresses_path)
			visit shipping_addresses_path
			expect(page).to have_content '1111111'
			expect(page).to have_content '東京都港区'
			expect(page).to have_content '上田晋也'
		end
		it '配送先画面のヘッダーからトップ画面へ遷移する' do
			click_on 'NAGANO CAKE'
			expect(current_path).to eq(root_path)
		end
	end
	context 'トップ〜商品詳細画面のテスト' do
		it 'おすすめ商品の画像を押すと該当商品の詳細画面に遷移する' do
			click_on product1.product_name
			expect(current_path).to eq('/products/' + product1.id.to_s)
		end
		it '商品詳細画面で情報が正しく表示されている' do
			click_on product1.product_name
			expect(page).to have_content product1.product_name
			expect(page).to have_content product1.product_description
			expect(page).to have_content product1.genre.name
			expect(page).to have_content product1.tax_included_price
		end
	end
	context '商品詳細画面のテスト' do
		before do
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
		end
		it 'カートに入れるボタンを押すとカート画面に遷移する' do
			expect(current_path).to eq(carts_path)
		end
		it 'カートの中身が正しく表示されている' do
			expect(page).to have_content product1.product_name
			expect(find_field('cart[quantity]').value).to eq 3.to_s
		end
		it '情報入力に進むボタンを押すと情報入力画面に遷移する' do
			click_on '情報入力に進む'
			expect(current_path).to eq(new_order_path)
		end
	end
	context '注文情報入力画面のテスト' do
		before do
			visit shipping_addresses_path
			fill_in 'shipping_address[postal_code]', with: '1111111'
			fill_in 'shipping_address[address]', with: '東京都港区'
			fill_in 'shipping_address[address_name]', with: '上田晋也'
			click_button '登録する'
			visit root_path
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
			click_on '情報入力に進む'
			choose 'address_info_shipping_address_info'
			select "1111111 東京都港区 上田晋也" , from: 'address'
			click_button '注文確認画面へ'
		end
		it '新たに登録した住所が選択できるようになっている' do
			expect(page).to have_content "1111111"
			expect(page).to have_content "東京都港区"
			expect(page).to have_content "上田晋也"
		end
		it '購入確定ボタンを押すとサンクスページに遷移する' do
			click_on '購入確定'
			expect(current_path).to eq(order_finish_path)
		end
		it 'サンクスページのヘッダーからトップ画面へ遷移する' do
			click_on '購入確定'
			click_on 'NAGANO CAKE'
			expect(current_path).to eq(root_path)
		end
	end
	context 'カートのテスト' do
		it 'おすすめ商品の画像を押すと該当商品の詳細画面に遷移する' do
			click_on product1.product_name
			expect(current_path).to eq('/products/' + product1.id.to_s)
		end
		it '商品詳細画面で情報が正しく表示されている' do
			click_on product1.product_name
			expect(page).to have_content product1.product_name
			expect(page).to have_content product1.product_description
			expect(page).to have_content product1.genre.name
			expect(page).to have_content product1.tax_included_price
		end
		it 'カートに入れるボタンを押すとカート画面に遷移する' do
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
			expect(current_path).to eq(carts_path)
		end
		it 'カートの中身が正しく表示されている' do
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
			expect(page).to have_content product1.product_name
			expect(find_field('cart[quantity]').value).to eq 3.to_s
		end
		it '情報入力に進むボタンを押すと情報入力画面に遷移する' do
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
			click_on '情報入力に進む'
			expect(current_path).to eq(new_order_path)
		end
	end
	context '注文情報で新たに住所を入力するテスト' do
		before do
			click_on product1.product_name
			select 3, from: 'cart_quantity'
			click_button 'カートに入れる'
			click_on '情報入力に進む'
			choose 'order_payment_method_クレジットカード'
			choose 'address_info_new_address_info'
			fill_in 'order[postal_code]', with: '2222222'
			fill_in 'order[address]', with: '北海道札幌市'
			fill_in 'order[name]', with: '福田和子'
			click_button '注文確認画面へ'
		end
		it '支払い情報を選択し住所を新たに入力して注文確認画面へを押すと注文確認画面に遷移する' do
			expect(current_path).to eq(order_confirm_path)
		end
		it '選択した商品、合計金額、配送方法が表示されている' do
			expect(page).to have_content 'ショートケーキ'
			expect(page).to have_content 2,300
		end
		it 'サンクスページに遷移する' do
			click_on '購入確定'
			expect(current_path).to eq(order_finish_path)
		end
		it 'サンクスページのヘッダーからマイページへ遷移する' do
			click_on '購入確定'
			mypage_link = find_all('a')[1].native.inner_text
			click_link mypage_link
			expect(current_path).to eq(customer_path)
		end
		it 'マイページから住所一覧画面へ遷移する' do
			click_on '購入確定'
			mypage_link = find_all('a')[1].native.inner_text
			click_link mypage_link
			click_link '一覧を見る', href: '/shipping_addresses'
			expect(current_path).to eq(shipping_addresses_path)
		end
		it '先ほど購入時に入力した住所が表示されている' do
			click_on '購入確定'
			mypage_link = find_all('a')[1].native.inner_text
			click_link mypage_link
			click_link '一覧を見る', href: '/shipping_addresses'
			expect(page).to have_content '2222222'
			expect(page).to have_content '北海道札幌市'
			expect(page).to have_content '福田和子'
		end
	end
	# ここまでは修正済み！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
	  	context '会員情報編集画面が表示される' do
	  		it '会員情報編集画面に遷移する' do
	  		#マイページへアクセスする
	  		visit customer_path
	  		#ページ内にあるHTML要素('a')の6番目の編集するボタンを探す
	  		edit_customer_link = find_all('a')[5].native.inner_text
	  		#上記で探した"編集する"リンクを押す
	  		click_link edit_customer_link
	  		#今現在のパスはイコール下記のURLと同じ
	  		expect(current_path).to eq('/customer/edit')
	  		end
	  		# it 'アラートが表示される', js: true do
	  		# visit edit_customer_path
	  		# # 会員情報編集画面で「退会するを押す」
	  		# click_on '退会する'
	  		# # 退会確認画面で「退会するを押す」
	  		# click_on '退会する'
	  		# # 　　　　　　　↑この退会するを押したらalertで「本当に退会しますか？」ってでるはず
	  		# # gemを入れてないからなのかrspecでalertが認識できない！！！！！！！！！！！！！！！！！！！！！！！！！！
	  		# expect(page.driver.switch_to.alert.text).to eq("本当に退会しますか？")
	  		# page.accept_confirm
	  		# # expect(current_path).to eq(root_path)
	  		# end
	  		it '「はい」を押すとトップ画面に遷移する' do
	  		visit edit_customer_path
	  		click_on '退会する'
	  		click_on '退会する'
	  		# gem入れたら下の行はアンコメントアウト
	  		# page.driver.browser.alert.accept
	  		expect(current_path).to eq(root_path)
	  		end
	  		it 'ヘッダが未ログイン状態になっている' do
	  		visit edit_customer_path
	  		click_on '退会する'
	  		click_on '退会する'
	  		# gem入れたら下の行はアンコメントアウト
	  		# page.driver.browser.alert.accept
	  		expect(page).to have_link 'ログイン', href: '/customers/sign_in'
	  		end
	  		it 'ヘッダからログイン画面に遷移する' do
	  		visit edit_customer_path
	  		click_on '退会する'
	  		click_on '退会する'
	  		click_on 'ログイン'
	  		expect(current_path).to eq('/customers/sign_in')
	  		end
	  		it'ログインが不可' do
	  		visit edit_customer_path
	  		click_on '退会する'
	  		click_on '退会する'
	  		click_on 'ログイン'
	  		fill_in 'customer[email]', with: 'kasuga@example.com'
	  		fill_in 'customer[password]', with: 'kasugakasuga'
	  		click_button 'ログイン'
	  		expect(page).to have_link 'ログイン', href: '/customers/sign_in'
	  		end

	  	end

end
RSpec.describe '登録情報変更のテスト', type: :feature do
	let!(:customer1) { Customer.create(email: "kasuga@example.com",
										password: "kasugakasuga",
										surname: "春日",
										name: "俊彰",
										kana_surname: "カスガ",
										kana_name: "トシアキ",
										postal_code: "1234567",
										address: "埼玉県所沢市",
										phone_number: "1234567890",
										account_status: true)}
	let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }

	before do
		visit new_customer_session_path
		fill_in 'customer[email]', with: customer1.email
		fill_in 'customer[password]', with: customer1.password
		click_button 'ログイン'
		visit edit_customer_path
		fill_in 'customer[address]', with: "明日花キララ"
		click_on '編集内容を保存する'
		visit edit_customer_path
		click_on '退会する'
		click_on '退会する'
		visit new_admin_session_path
		fill_in 'admin[email]', with: admin.email
		fill_in 'admin[password]', with: admin.password
		click_button 'ログイン'
	end
	it 'トップ画面が表示される' do
		expect(page).to have_content '本日の注文件数'
	end
	it '会員一覧画面が表示される' do
		customer_index_link = find_all('a')[2].native.inner_text
		click_link customer_index_link
		expect(current_path).to eq(admin_customers_path)
	end
	it '先ほど退会したユーザが「退会済」になっている' do
		visit admin_customers_path
		expect(customer1.reload.account_status).to eq false
	end
	it '会員情報詳細画面に遷移する' do
		visit admin_customers_path
		click_link '春日 俊彰', href: '/admin/customers/1'
		expect(current_path).to eq('/admin/customers/1')
	end
	it '変更した住所が表示されている' do
		visit admin_customers_path
		click_link '春日 俊彰', href: '/admin/customers/1'
		expect(customer1.reload.address).to eq("明日花キララ")
	end
	it 'ログイン画面が表示される' do
		click_on 'ログアウト'
		expect(current_path).to eq(new_admin_session_path)
	end
end
