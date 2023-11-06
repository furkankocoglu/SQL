--86. a.Bu ülkeler hangileri..?
select distinct(ship_country)from orders

--87. En Pahalı 5 ürün
select * from products 
order by unit_price desc limit 5


--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select count(*) from orders where customer_id = 'ALFKI'


--89. Ürünlerimin toplam maliyeti
select sum(unit_price*units_in_stock) from products

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum ((unit_price-(unit_price*discount))*quantity) from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products

--92. En Pahalı Ürünün Adı
select product_name from products
order by unit_price desc limit 1


--93. En az kazandıran sipariş
select * from orders where order_id = (select order_id from (select od.order_id,sum(unit_price*quantity) as profit from orders o
										inner join order_details od
										on od.order_id = o.order_id
										group by od.order_id order by profit asc limit 1))


--94. Müşterilerimin içinde en uzun isimli müşteri
select * from customers where customer_id =(select customer_id from (select length (company_name) as uzun, company_name,customer_id from customers 
											 order by uzun desc limit 1))



--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name,last_name, EXTRACT(YEAR FROM AGE(current_date, birth_date)) AS age from employees 
select first_name,last_name, (current_date-birth_date)/365 AS age from employees 

--96. Hangi üründen toplam kaç adet alınmış..?
select p.product_name,sum(quantity) as total from products p
inner join order_details od
on p.product_id = od.product_id
group by p.product_name order by p.product_name

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select order_id,sum(quantity*unit_price) from order_details
group by order_id

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select count(*),category_name from products p
inner join categories c
on p.category_id=c.category_id
group by category_name


--99. 1000 Adetten fazla satılan ürünler?
select product_name,sum(quantity) as sum_quantity from order_details od
inner join products p
on od.product_id=p.product_id
group by product_name
having sum(quantity) > 1000 order by product_name


--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select company_name from customers c
left join orders o
on c.customer_id = o.customer_id
where order_id isNull 


--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select product_name,company_name from products p
inner join suppliers s
on p.supplier_id = s.supplier_id



--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select order_id,ship_name,shipped_date from orders


--103. Hangi siparişi hangi müşteri verir..?
select company_name,order_id from orders o
inner join customers c
on o.customer_id = c.customer_id

--104. Hangi çalışan, toplam kaç sipariş almış..?
select first_name, count(*) from orders o
inner join employees e
on o.employee_id=e.employee_id
group by first_name

--105. En fazla siparişi kim almış..?
select first_name, count(*) from orders o
inner join employees e
on o.employee_id=e.employee_id
group by first_name order by count(*) desc limit 1


--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select  order_id,first_name,company_name from orders o
inner join employees e
on o.employee_id=e.employee_id
inner join customers c
on c.customer_id=o.customer_id


--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select product_name,category_name,company_name from products p
inner join categories c
on p.category_id=c.category_id
inner join suppliers s
on s.supplier_id = p.supplier_id


--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, 
--hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, 
--hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id,c.company_name,e.first_name,o.order_date,o.ship_name,p.product_name,sum(od.quantity),od.unit_price,ca.category_name,s.company_name from order_details od
inner join products p
on p.product_id=od.product_id
inner join orders o
on o.order_id = od.order_id
inner join employees e
on o.employee_id=e.employee_id
inner join customers c
on c.customer_id=o.customer_id
inner join categories ca
on ca.category_id=p.category_id
inner join suppliers s
on s.supplier_id = p.supplier_id
group by o.order_id,c.company_name,e.first_name,o.order_date,o.ship_name,p.product_name,od.unit_price,ca.category_name,s.company_name


--109. Altında ürün bulunmayan kategoriler
select * from categories c
left join products p
on c.category_id = p.category_id
where product_id isnull

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select *  from customers where contact_title like '%Manager%'

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select * from customers where company_name like 'Fr___'

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers where phone like '(171)%'


--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products where quantity_per_unit like '%boxes%'

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select company_name,phone  from customers where contact_title like '%Manager%' and country in ('France','Germany')

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select * from products order by unit_price desc limit 10


--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select * from customers order by country, city

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name,last_name,(current_date-birth_date)/365 AS age from employees 

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders where (shipped_date-order_date) >= 35

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select category_name 
from categories
where category_id = 
(select category_id from products order by unit_price desc limit 1)

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select * from products where category_id=ANY(select category_id from categories where category_name like '%on%')
--121. Konbu adlı üründen kaç adet satılmıştır.
select product_name, sum(quantity) from order_details od
inner join products p
on od.product_id=p.product_id
group by product_name
having product_name='Konbu'
--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct(product_name)) from products p
inner join suppliers s
on s.supplier_id=p.supplier_id
where s.country='Japan'
--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight) as "En Yüksek",min(freight) as "En Düşük", avg(freight) as "Ortalama" 
from orders where  date_part('year',order_date)=1997
--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers where fax is not null
--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select * from orders where shipped_date between '1996-07-16' and '1996-07-30'