require 'rails_helper'

RSpec.describe "管理画面のテスト", type: :feature do
	# letはインスタンス変数
	let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }
	let!(:customer) { Customer.create(email: "kasuga@example.com", password: "kasugakasuga", surname: "春日", name: "俊彰", kana_surname: "カスガ", kana_name: "トシアキ", postal_code: "1234567", address: "埼玉県所沢市", phone_number: "1234567890", account_status: true) }
	let!(:genre) { Genre.create(name: "りんご飴", is_active: true) }
	let!(:product){ Product.create(product_name: "りんご飴", product_description: "おいしいおいしいりんご飴です。", genre_id: genre.id, sale_status: true, tax_included_price: 200 ) }
	let!(:order) { Order.create!(customer_id: customer.id, payment_method: 0, postage: 800, order_status: 0, total_payment: 3400, postal_code: "1234567", address: "埼玉県所沢市", name: "春日 俊彰") }
	let!(:orders_product) { OrdersProduct.create(order_id: order.id, product_id: product.id, quantity: 3, price: 500, production_status: 0) }

	before do
	    	visit new_admin_session_path
			fill_in 'admin[email]', with: admin.email
			fill_in 'admin[password]', with: admin.password
			click_button 'ログイン'
	end

	context "メールアドレス・パスワードでログインする" do
		it "トップ画面が表示される" do
			expect(current_path).to eq (admin_root_path)
		end
	end

	context "ヘッダから注文履歴一覧へのリンクを押下する" do
		it "注文履歴一覧が表示される" do
			visit admin_root_path
			orders_link = find_all("a")[2].native.inner_text
			click_link orders_link

			expect(current_path).to eq (admin_orders_path)
		end
	end

	 context "前テストでの注文の詳細表示ボタンを押下する" do
	 	it "注文詳細画面が表示される" do
	 		visit admin_orders_path
	 		click_link order.created_at.strftime("%Y-%m-%d %H:%M"), href: admin_order_path(order)
	 		expect(current_path).to eq(admin_order_path(order))
	 	end
	 end

	 context "注文詳細画面" do
	 	before do
	 		visit admin_orders_path
	 	end

	 	it "注文ステータスが「入金確認」、製作ステータスが「製作待ち」に更新される" do
	 		click_link order.created_at.strftime("%Y-%m-%d %H:%M"), href: admin_order_path(order)
	 		# expect(page). to have_select('order[order_status]', selected: '入金待ち')
	 		select '入金確認', from: 'order[order_status]'
	 		find('#order_status').click
	 		visit admin_order_path(order)
	 		expect(page). to have_select('orders_product[production_status]', selected: '製作待ち')
	 		expect(page). to have_select('order[order_status]', selected: '入金確認')
	 	end

	 	it "注文ステータスが「製作中」に更新される" do
	 		 click_link order.created_at.strftime("%Y-%m-%d %H:%M"), href: admin_order_path(order)
	 		 select "製作中", from: "orders_product[production_status]"
	 		 find("#production_status").click
	 		 expect(orders_product.reload.production_status).to eq ("製作中")
	 		 expect(order.reload.order_status).to eq ("製作中")
	 	end

	 	it "注文ステータスが「発送待準備中」に更新される" do
	 		click_link order.created_at.strftime("%Y-%m-%d %H:%M"), href: admin_order_path(order)
	 		select "製作完了", from: "orders_product[production_status]"
	 		find("#production_status").click
	 		expect(orders_product.reload.production_status).to eq ("製作完了")
	 		expect(order.reload.order_status).to eq ("発送準備中")
	 	end

	 	it "注文ステータスが「発送済み」に更新される" do
	 		click_link order.created_at.strftime("%Y-%m-%d %H:%M"), href: admin_order_path(order)
	 		select '発送済み', from: 'order[order_status]'
	 		find('#order_status').click
	 		expect(order.reload.order_status).to eq ("発送済み")
	 	end
	 end

	context "ヘッダからログアウトボタンを押下する" do
		it "ログイン画面に遷移する" do
			loguot_link = find_all("a")[4].native.inner_text
			click_link loguot_link

			expect(current_path).to eq (new_admin_session_path)
		end
	end
end

RSpec.describe "ECサイト", type: :feature do

	let!(:admin) { Admin.create(email: "admin@example.com", password: "adminadmin") }
	let!(:customer) { Customer.create(email: "kasuga@example.com", password: "kasugakasuga", surname: "春日", name: "俊彰", kana_surname: "カスガ", kana_name: "トシアキ", postal_code: "1234567", address: "埼玉県所沢市", phone_number: "1234567890", account_status: true) }
	let!(:genre) { Genre.create(name: "りんご飴", is_active: true) }
	let!(:product){ Product.create(product_name: "りんご飴", product_description: "おいしいおいしいりんご飴です。", genre_id: genre.id, sale_status: true, tax_included_price: 200 ) }
	let!(:order) { Order.create!(customer_id: customer.id, payment_method: 0, postage: 800, order_status: 4, total_payment: 3400, postal_code: "1234567", address: "埼玉県所沢市", name: "春日 俊彰") }
	let!(:ordersproduct) { OrdersProduct.create(order_id: order.id, product_id: product.id, quantity: 3, price: 500, production_status: 0) }

 	before do
 		visit new_customer_session_path
 		fill_in "customer[email]", with: customer.email
 		fill_in "customer[password]", with: customer.password
 		click_button "ログイン"
 	end

 	context "注文した会員情報でログインをする" do
 		it "トップ画面に遷移する" do
 			expect(current_path).to eq (root_path)
 		end

 		it "ヘッダがログイン後の表示に変わっている" do
 			header_link = find_all("a")[0].native.inner_text
 			expect(header_link).to match(/マイページ/i)
 			header_link = find_all("a")[1].native.inner_text
 			expect(header_link).to match(/商品一覧/i)
 			header_link = find_all("a")[2].native.inner_text
 			expect(header_link).to match(/カート/i)
 			header_link = find_all("a")[3].native.inner_text
 			expect(header_link).to match(/ログアウト/i)
 		end
 	end

 	context "ヘッダからマイページに遷移する" do
 		it "マイページが表示される" do
 			mypage_link = find_all("a")[0].native.inner_text
 			click_on mypage_link

 			expect(current_path).to eq (customer_path)
 		end
 	end

 	 context "注文履歴一覧を表示するボタンを押下する" do
 		it "注文履歴一覧に遷移する" do
 	 		visit customer_path
 	 		find('#orders').click
 	 		expect(current_path).to eq (orders_path)
 	 	end
 	 end

 	 context "注文履歴から先ほど注文した注文の詳細表示ボタンを押下する" do
 	 	before do
 	 	 	 visit orders_path
 	 	 	end

 	 	it "注文履歴詳細画面に遷移する" do
 	 	 	click_link '表示する', href: "/orders/1"

 	 	 	expect(current_path).to eq "/orders/1"
 	 	end

 	 	 it "注文のステータスが「発送済」になっている" do
 	 	 expect(order.order_status).to eq "発送済み"
 	 	 end

 	 end

 end














