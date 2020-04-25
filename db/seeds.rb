Admin.create(
	email: "admin@example.com",
	password: "adminadmin"
	)

Customer.create(
	email: "kasuga@example.com",
	password: "kasugakasuga",
	surname: "春日",
	name: "俊彰",
	kana_surname: "カスガ",
	kana_name: "トシアキ",
	postal_code: "1234567",
	address: "埼玉県所沢市",
	phone_number: "1234567890",
	)

Customer.create(
	email: "wakabayashi@example.com",
	password: "wakabayashi",
	surname: "若林",
	name: "正恭",
	kana_surname: "ワカバヤシ",
	kana_name: "マサヤス",
	postal_code: "1234567",
	address: "東京都渋谷区笹塚",
	phone_number: "1234567890",
	)

Genre.create([
	{ name: "ケーキ", is_active: true },
	{ name: "焼き菓子", is_active: true },
	{ name: "プリン", is_active: true },
	{ name: "キャンディ", is_active: true }
	])

Product.create(
	product_name: "ショートケーキ",
	product_description: "おいしいおいしいショートケーキです。",
	genre_id: 1,
	sale_status: true,
	tax_included_price: 500
	)

Product.create(
	product_name: "モンブラン",
	product_description: "おいしいおいしいモンブランです。",
	genre_id: 1,
	sale_status: true,
	tax_included_price: 450
	)

Product.create(
	product_name: "チョコレートケーキ",
	product_description: "おいしいおいしいチョコレートケーキです。",
	genre_id: 1,
	sale_status: true,
	tax_included_price: 550
	)

Product.create(
	product_name: "プリン",
	product_description: "おいしいおいしいプリンです。",
	genre_id: 3,
	sale_status: true,
	tax_included_price: 300
	)

Product.create(
	product_name: "クッキー",
	product_description: "おいしいおいしいクッキーです。",
	genre_id: 2,
	sale_status: true,
	tax_included_price: 100
	)

Product.create(
	product_name: "マカロン",
	product_description: "おいしいおいしいマカロンです。",
	genre_id: 2,
	sale_status: true,
	tax_included_price: 250
	)

Product.create(
	product_name: "りんご飴",
	product_description: "おいしいおいしいりんご飴です。",
	genre_id: 4,
	sale_status: true,
	tax_included_price: 200
	)

ShippingAddress.create(
	customer_id: 1,
	address_name: "佐藤満春",
	postal_code: "1234567",
	address: "東京都町田市"
	)

ShippingAddress.create(
	customer_id: 2,
	address_name: "佐藤満春",
	postal_code: "1234567",
	address: "東京都町田市"
	)

Cart.create(
	customer_id: 1,
	product_id: 1,
	quantity: 3
	)

Cart.create(
	customer_id: 1,
	product_id: 3,
	quantity: 2
	)

Order.create(
	customer_id: 1,
	payment_method: 0,
	postage: 800,
	order_status: 0,
	total_payment: 3400,
	postal_code: "1234567",
	address: "埼玉県所沢市",
	name: "春日 俊彰"
	)

OrdersProduct.create(
	order_id: 1,
	product_id: 1,
	quantity: 3,
	price: 500,
	production_status: 0
	)

OrdersProduct.create(
	order_id: 1,
	product_id: 3,
	quantity: 2,
	price: 550,
	production_status: 0
	)

