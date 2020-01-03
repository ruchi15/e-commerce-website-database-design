-- Stored Procedure for registering BUYER
set serveroutput on;

CREATE OR REPLACE PROCEDURE REGISTERBUYER ( 
u_userid user1.userid%TYPE,
u_userType user1.user_type%TYPE,
u_dateCreated user1.datecreated%TYPE,
b_id BUYER.BUYERID%TYPE,  
b_membership buyer.membership%TYPE,
b_buyerFirstName buyer.buyerfirstname%TYPE,
b_buyerLastName buyer.buyerlastname%TYPE,
b_phoneNumber buyer.phonenumber%TYPE,
b_email buyer.email%TYPE)  
IS  
BEGIN  
INSERT INTO USER1 (USERID, USER_TYPE, DATECREATED)  
VALUES (u_userid, u_userType, u_dateCreated);

INSERT INTO BUYER (BUYERID, USERID, MEMBERSHIP, BUYERFIRSTNAME, BUYERLASTNAME, PHONENUMBER, EMAIL)  
VALUES (b_id, u_userid, b_membership, b_buyerFirstName, b_buyerLastName, b_phoneNumber, b_email);

COMMIT;  
END;
/

CREATE OR REPLACE PROCEDURE REGISTERSELLER ( 
u_userid user1.userid%TYPE,
u_userType user1.user_type%TYPE,
u_dateCreated user1.datecreated%TYPE,
s_id seller.sellerid%TYPE,  
s_companyName seller.companyname%TYPE,
s_sellerFirstName seller.sellerfirstname%TYPE,
s_sellerLastName seller.sellerlastname%TYPE,
s_phoneNumber seller.phonenumber%TYPE,
s_email seller.email%TYPE,
s_logo seller.logo%TYPE)  
IS  
BEGIN  
INSERT INTO USER1 (USERID, USER_TYPE, DATECREATED)  
VALUES (u_userid, u_userType, u_dateCreated);

INSERT INTO SELLER (SELLERID, USERID, companyname, sellerfirstname, sellerlastname, phonenumber, email, logo)  
VALUES (s_id, u_userid, s_companyName, s_sellerFirstName, s_sellerLastName, s_phoneNumber, s_email, s_logo);

COMMIT;  
END;
/
BEGIN
   REGISTERBUYER(1, 'b', SYSDATE, 12345678, 'Y', 'JANE', 'DOE', '123-456-7890', 'jdoe@gmail.com');
END;
BEGIN
   REGISTERSELLER(456, 'S', SYSDATE-1, 2, 'AMAZON', 'ANANT', 'PRAKASH', '469-350-1307', 'ruchi@gmail.com', NULL);
END;


select * from user1;
SELECT * FROM BUYER;
select * from SELLER;



-- Stored Procedure for registering SELLER




-- Stored Procedure for storing an order

CREATE OR REPLACE PROCEDURE StoreProduct ( 
p_productID product.productid%TYPE,
p_department product.department%TYPE,
p_productName product.productname%TYPE,  
p_unitPrice product.unitprice%TYPE,
p_productDesc product.productdescription%TYPE,
p_unitsInStock product.unitsinstock%TYPE,
p_unitsInOrder product.unitsinorder%TYPE,
p_itemPicture product.itempicture%TYPE)  
IS  
BEGIN  

INSERT INTO PRODUCT(PRODUCTID, DEPARTMENT, PRODUCTNAME, UNITPRICE, PRODUCTDESCRIPTION, UNITSINSTOCK, UNITSINORDER, ITEMPICTURE)  
VALUES (p_productID, p_department, p_productName, p_unitPrice, p_productDesc, p_unitsInStock, p_unitsInOrder, p_itemPicture);

COMMIT;  
END;
/

BEGIN
   StoreProduct(1, 'Electronics', 'Tablet', 5000, 'tablet', 100, 0, NULL);
   StoreProduct(2, 'Sports', 'Football', 100, 'Signed by Messi', 100, 0, NULL);
   StoreProduct(3, 'Kitchen', 'SilverWare', 50, 'kitchen ware', 100, 0, NULL);
   StoreProduct(4, 'Education', 'DB Design Book', 100, 'Study Well', 100, 0, NULL);
END;
/

CREATE OR REPLACE PROCEDURE ADD_ADDRESS ( 
u_AddressID Address.AddressID%TYPE,
u_UserID Address.UserID%TYPE,
u_Address_Type Address.Address_Type%TYPE,
u_AddressLine1 Address.AddressLine1%Type,
u_City Address.City%TYPE,
u_Province Address.Province%TYPE,
u_Country Address.Country%TYPE,
u_PostalCode Address.PostalCode%TYPE
)  
IS  
BEGIN  
INSERT INTO Address (AddressID ,UserID ,Address_Type ,AddressLine1 ,City ,Province ,Country ,PostalCode)  
VALUES (u_AddressID, u_UserID, u_Address_Type, u_AddressLine1, u_City, u_Province, u_Country, u_PostalCode);
COMMIT;  
END;
/

BEGIN
   ADD_ADDRESS('H1', 1, 'Home', '7815 McCallum Blvd.', 'Dallas', 'Texas', 'US', 75252);
   ADD_ADDRESS('W1', 1, 'Work', '2.104, ECSS, UT Dallas', 'Dallas', 'Texas', 'US', 75252);
END;

CREATE OR REPLACE PROCEDURE Insert_into_Cart ( 
s_ShoppingCartID Cart_Product.ShoppingCartID%TYPE ,
s_ProductID Cart_Product.ProductID%TYPE,
s_USerID User1.UserID%TYPE
)  
IS
BEGIN  
DECLARE 
counter INT;
pcount VARCHAR(8);
BEGIN
Select count(*) into pcount from Product where ProductID=s_ProductID;

if pcount>0
then
Select count(*) into counter from Cart_Product where ShoppingCartID = s_ShoppingCartID;
INSERT INTO Cart_Product(ShoppingCartID,ProductID) 
VALUES (s_ShoppingCartID, s_ProductID);
if counter = 0
THEN 
    INSERT into Shopping_Cart(ShoppingCartID ,UserID ,Quantity)
    VALUES (s_ShoppingCartID,s_USerID,counter+1);
ELSE
    UPDATE Shopping_Cart SET Quantity = counter+1 where ShoppingCartID = s_ShoppingCartID;
END IF;
COMMIT;
else
    Raise_Application_Error(-20005, 'No such Product available');
END IF;
END;
END;
/

BEGIN
    Insert_into_Cart('SH1', 1, 1);
    Insert_into_Cart('SH1', 2, 1);
END;

CREATE OR REPLACE PROCEDURE Quantity_IN_ShoppingCart ( 
s_ShoppingCartID Cart_Product.ShoppingCartID%TYPE ,
qty out INT
)  
IS
BEGIN  
Declare counter INT;
BEGIN
Select count(*) into counter from Cart_Product where ShoppingCartID = s_ShoppingCartID;
if counter = 0
THEN 
    Raise_Application_Error(-20000, 'No item in Shopping Cart');
ELSE
    qty:=counter;
END IF;  
END;
END;
/

set serveroutput on;
DECLARE
qty INT;
BEGIN
    Quantity_IN_ShoppingCart('SH1',qty);
    dbms_output.put_line('Result is '||qty);
END;

CREATE OR REPLACE PROCEDURE Products_IN_ShoppingCart ( 
s_ShoppingCartID IN Cart_Product.ShoppingCartID%TYPE ,
productList out SYS_REFCURSOR
)  
IS
BEGIN  

OPEN productList FOR
Select ProductID from Cart_Product where ShoppingCartID = s_ShoppingCartID;

END;
/

set serveroutput on;
DECLARE
cur SYS_REFCURSOR;
product VARCHAR(8);
BEGIN
    Products_IN_ShoppingCart('SH1',cur);
    LOOP
    FETCH cur into product;
    EXIT WHEN cur%NOTFOUND;
    dbms_output.put_line('Result is '||product);
END LOOP;
CLOSE cur;
END;





CREATE OR REPLACE PROCEDURE PriceEngine ( 
s_ShoppingCartID Cart_Product.ShoppingCartID%TYPE ,
price out DECIMAL
)  
IS
BEGIN
DECLARE 
prodList SYS_REFCURSOR;
pr DECIMAL;
product VARCHAR(8);
p DECIMAL;
BEGIN  
Products_IN_ShoppingCart(s_ShoppingCartID, prodList);
pr:=0;
LOOP
    FETCH prodList into product;
    EXIT WHEN prodList%NOTFOUND;
    p:=0;
    Select UnitPrice into p from Product where ProductID=product;
    pr:= pr+p;
    dbms_output.put_line(pr || ' ' || p);
END LOOP;
 CLOSE prodList; 
 price:=pr;
END;
END;
/


set serveroutput on;
DECLARE
price DECIMAL;
BEGIN
    PriceEngine('SH1',price);
    dbms_output.put_line('Order price is '|| price);
END;

CREATE OR REPLACE Procedure Insert_Order_Product(
OrID Orders.OrderID%TYPE,
ListOfProducts SYS_REFCURSOR)
IS
BEGIN
DECLARE 
product VARCHAR(8);
BEGIN
    LOOP
    FETCH ListOfProducts into product;
    EXIT WHEN ListOfProducts%NOTFOUND;

    Insert into order_product(OrderID,ProductID)
    VALUES(OrID,product);
END LOOP;
END;
END;


--Orders
CREATE OR REPLACE PROCEDURE Place_Order ( 
OrderID Orders.OrderID%TYPE, 
UserID Orders.UserID%TYPE,
ShipperID Orders.ShipperID%TYPE
)
IS 
BEGIN
DECLARE
s_cart_id VARCHAR(8);
qty INT;
price DECIMAL;
Tax DECIMAL;
dt DATE;
productList SYS_REFCURSOR;
BEGIN  
s_cart_id:='';  
Select Distinct ShoppingCartID into s_cart_id from Shopping_Cart s where s.UserID = UserID;
Products_IN_ShoppingCart ( s_cart_id,productList );  
Insert_Order_Product(OrderID , productList);
Quantity_IN_ShoppingCart(s_cart_id,qty);
PriceEngine(s_cart_id,price);
Tax:=0.1*price;
dt := '';
Select SYSDATE into dt from dual;
INSERT into Orders(OrderID , 
UserID ,
ShipperID ,
OrderDate ,
RequiredDate ,
Tax,
TransactionStatus ,
PaymentDate ,
ItemQuantity ,
Price)
VALUES (OrderID , 
UserID ,
ShipperID ,
dt ,
dt+7,
Tax,
'PENDING' ,
dt,
qty ,
price);
COMMIT;  
END;
END;
/

BEGIN
    Place_Order(999,1,'BlueDart');
END;


CREATE OR REPLACE PROCEDURE Insert_Payment_CARD ( 
p_paymentID payment.paymentid%TYPE,
p_orderID payment.orderid%TYPE,
p_paymentType payment.payment_type%TYPE,
p_cardid payment_card.cardid%TYPE,
p_cardnumber payment_card.cardnumber%TYPE,
p_cardexpmonth payment_card.cardexpmonth%TYPE,
p_cardexpyear payment_card.cardexpyear%TYPE
)  
IS  
BEGIN

INSERT INTO Payment(paymentid, orderid, payment_type) 

VALUES (p_paymentID, p_orderID, p_paymentType);

INSERT INTO PAYMENT_CARD(cardid, paymentid, cardnumber, cardexpmonth, cardexpyear)
values (p_cardid, p_paymentID, p_cardnumber, p_cardexpmonth, p_cardexpyear);

COMMIT;  
END;

BEGIN
   Insert_Payment_CARD('XYZ', 999, 'C', '343252', '34456678', '12', '2023');
END;




-- Insert payment in payment gift card

CREATE OR REPLACE PROCEDURE Insert_Payment_GIFT_CARD ( 
p_paymentID payment.paymentid%TYPE,
p_orderID payment.orderid%TYPE,
p_paymentType payment.payment_type%TYPE,
p_giftcardid payment_giftcard.giftcardid%TYPE,
p_giftcardamount payment_giftcard.giftcardamount%TYPE,
p_giftcardnumber payment_giftcard.giftcardnumber%TYPE,
p_giftcardexpmonth payment_giftcard.giftcardexpmonth%TYPE,
p_giftcardexpyear payment_giftcard.giftcardexpyear%TYPE
)  
IS  
BEGIN

INSERT INTO Payment(paymentid, orderid, payment_type) 

VALUES (p_paymentID, p_orderID, p_paymentType);

INSERT INTO PAYMENT_GIFTCARD(giftcardid, paymentid, giftcardamount, giftcardnumber, giftcardexpmonth, giftcardexpyear)
values (p_giftcardid, p_paymentID, p_giftcardamount, p_giftcardnumber, p_giftcardexpmonth, p_giftcardexpyear);

COMMIT;  
END;

BEGIN
   Insert_Payment_GIFT_CARD('456', '999', 'G', '76756465', '100', '332334', '12', '2020');
END;


select * from payment;
select * from payment_card;
select * from payment_giftcard;



