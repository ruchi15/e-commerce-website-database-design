--USE amazon ;
-- User Schema 

Drop TABLE User1;
Drop TABLE Buyer;
Drop TABLE Seller;
Drop TABLE Address; 

Drop TABLE Product;
Drop TABLE Shopping_Cart;
Drop TABLE Wishlist;
Drop TABLE Reviews;
Drop TABLE Discount;
Drop TABLE Offer;

Drop TABLE Wishlist_Product;
Drop TABLE Order_Product;
DROP TABLE Cart_Product;

Drop TABLE Orders;
Drop TABLE Invoice;
Drop TABLE Shipper;
Drop TABLE Payment;
Drop TABLE Payment_Card;
Drop TABLE Payment_Giftcard;


CREATE TABLE User1(
  UserID VARCHAR(8) NOT NULL,
  USER_TYPE VARCHAR(1) NOT NULL,
  DateCreated DATE NOT NULL,
  PRIMARY KEY (UserID)
  );
-- Users can be buyers and sellers but will have different accounts. 

CREATE TABLE Buyer(
  BuyerID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  Membership VARCHAR(1) NOT NULL,
  BuyerFirstName VARCHAR(50) NOT NULL,
  BuyerLastName VARCHAR(50) NULL,
  PhoneNumber VARCHAR(15) DEFAULT 'xxx-xxx-xxxx' NOT NULL,
  Email VARCHAR(50) NOT NULL,
  PRIMARY KEY (UserID)
  );
  
CREATE TABLE Seller (
  SellerID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  CompanyName VARCHAR(50) NOT NULL,
  SellerFirstName VARCHAR(50) NOT NULL,
  SellerLastName VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(15) DEFAULT 'xxx-xxx-xxxx' NOT NULL,
  Email VARCHAR(50) NOT NULL,
  Logo BLOB NULL,
  PRIMARY KEY (UserID));
  
--Can add multiple addresses so using AddressID as a PrimaryKey
CREATE TABLE Address (
  AddressID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  Address_Type VARCHAR(20) NOT NULL,
  AddressLine1 VARCHAR(50) NULL,
  City VARCHAR(50) NULL,
  Province VARCHAR(50) NULL,
  Country VARCHAR(50) NULL,
  PostalCode VARCHAR(10) NULL,
  PRIMARY KEY (AddressID));

--CREATE INDEX UserID_idx ON Sellers (UserID ASC);
-- Product Schema 

CREATE TABLE Product (
  ProductID VARCHAR(8) NOT NULL,
  Department VARCHAR(50) NOT NULL,
  ProductName VARCHAR(50) NOT NULL,
  UnitPrice DECIMAL NOT NULL,
  ProductDescription VARCHAR(255) NULL,
  UnitsInStock INT NULL,
  UnitsInOrder INT NULL,
  ItemPicture BLOB NULL,
  PRIMARY KEY (ProductID));
  

CREATE TABLE Shopping_Cart (
  ShoppingCartID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  Quantity VARCHAR(8),
  PRIMARY KEY (ShoppingCartID));

--CREATE INDEX ProductID_idx ON Shopping_Cart (ProductID ASC);


CREATE TABLE Wishlist (
  WishlistID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  PRIMARY KEY (WishlistID));

--CREATE INDEX ProductID_idx ON Wishlist (ProductID ASC);

CREATE TABLE Reviews (
  ReviewID VARCHAR(8) NOT NULL,
  ProductID VARCHAR(8) NOT NULL,
  UserID VARCHAR(8) NOT NULL,
  CustomerReview VARCHAR(100) NULL,
  Rating VARCHAR(1) NOT NULL,
  PRIMARY KEY (ReviewID));
  
CREATE TABLE Offer (
  OfferID VARCHAR(8) NOT NULL,
  ProductID VARCHAR(8) NULL,
  OfferAmount VARCHAR(8) NULL,
  PRIMARY KEY (OfferID));
  
--CREATE INDEX fk_Product_has_Discount_Discount1_idx ON Offer (DiscountID ASC);
--
--CREATE INDEX fk_Product_has_Discount_Product1_idx ON Offer (ProductID ASC);

--Relationsgip between Order and Product

-- Payments
CREATE TABLE Orders (
  OrderID VARCHAR(8) NOT NULL, 
  UserID VARCHAR(8) NOT NULL,
  ShipperID VARCHAR(8) NOT NULL,
  OrderDate DATE NOT NULL,
  RequiredDate DATE NOT NULL,
  Tax DECIMAL NOT NULL,
  TransactionStatus VARCHAR(50) NOT NULL,
  PaymentDate DATE NOT NULL,
  ItemQuantity INT NULL,
  Price DECIMAL NOT NULL,
  PRIMARY KEY (OrderID));
  
CREATE TABLE Order_Product (
  OrderID VARCHAR(8) NOT NULL,
  ProductID VARCHAR(8) NOT NULL,
  PRIMARY KEY (OrderID,ProductID));
  
  
CREATE TABLE Cart_Product (
  ShoppingCartID VARCHAR(8) NOT NULL,
  ProductID VARCHAR(8) NOT NULL,
  PRIMARY KEY (ShoppingCartID,ProductID));
  
CREATE TABLE WishList_Product (
  WishlistID VARCHAR(8) NOT NULL,
  ProductID VARCHAR(8) NOT NULL,
  PRIMARY KEY (WishlistID,ProductID));

CREATE TABLE Invoice (
  OrderID VARCHAR(8) NOT NULL, 
  InvoiceID VARCHAR(8) NOT NULL,
  Invoice_Type VARCHAR(4) NOT NULL,
  InvoiceAmount DECIMAL NOT NULL,
  PRIMARY KEY (InvoiceID));
  
  
--
--CREATE INDEX UserID_idx ON Orders (UserID ASC);
--
--CREATE INDEX ShipperID_idx ON Orders (ShipperID ASC);



CREATE TABLE Shipper (
  ShipperID VARCHAR(8) NOT NULL,
  ShipperCompanyName VARCHAR(50) NULL,
  ContactName VARCHAR(50) NULL,
  Phone VARCHAR(15) NULL,
  PRIMARY KEY (ShipperID));

--CREATE UNIQUE INDEX UNIQUE_ShipperID ON Shipper (ShipperID ASC);



-- Payments . Amazon allows you to pay using multiple options only when one of them is giftcard option.


CREATE TABLE Payment (
  PaymentID VARCHAR(8) NOT NULL,
  OrderID VARCHAR(8) NOT NULL,
  Payment_Type VARCHAR(1) NOT NULL,
  PRIMARY KEY (PaymentID));

--CREATE INDEX OrderID_idx ON Payment (OrderID ASC);

CREATE TABLE Payment_Card (
  CardID VARCHAR(8) NOT NULL,
  PaymentID VARCHAR(8) NOT NULL,
  CardNumber VARCHAR(20) NOT NULL,
  CardExpMonth INT NOT NULL,
  CardExpYear INT NOT NULL,
  PRIMARY KEY (PaymentID));

--CREATE INDEX PaymentID_idx ON Payment_CreditCard (PaymentID ASC);

--CREATE INDEX fk_Orders_has_Product_Product1_idx ON Orders_has_Product (Product_ProductID ASC);
--
--CREATE INDEX fk_Orders_has_Product_Orders1_idx ON Orders_has_Product (Orders_OrderID ASC);


CREATE TABLE Payment_Giftcard (
  GiftcardID VARCHAR(8) NOT NULL,
  PaymentID VARCHAR(8) NOT NULL,
  GiftCardAmount VARCHAR(8) NOT NULL,
  GiftCardNumber VARCHAR(16) NOT NULL,
  GiftcardExpMonth VARCHAR(2) NOT NULL,
  GiftcardExpYear VARCHAR(4) NOT NULL,
  PRIMARY KEY (PaymentID));

--CREATE INDEX PaymentID_idx ON Payment_Giftcard (PaymentID ASC);

--USE amazon ;
--
--CREATE TABLE IF NOT EXISTS view1 (id INT);
--
--DROP TABLE view1;
--USE amazon;

-- Orders and Payments One to One, Membership and Buyers has one to one relationship.
-- One Department Has Many Products, One User Can have many orders. One User can have many addresses.
-- One product can be in many wishlist and One wishlist can contain many products.Many order has many products. Many to many Shopping Cart and Product

ALTER TABLE Buyer ADD CONSTRAINT fk_uid_buyer FOREIGN KEY(UserID) REFERENCES User1(UserID) on delete cascade;
ALTER TABLE Seller ADD CONSTRAINT fk_uid_seller FOREIGN KEY(UserID) REFERENCES User1(UserID) on delete cascade;
ALTER TABLE Address ADD CONSTRAINT fk_uid_user_add FOREIGN KEY(UserID) REFERENCES User1(UserID) on delete cascade;
ALTER TABLE Shopping_Cart ADD CONSTRAINT fk_cart_User FOREIGN KEY(UserID) REFERENCES User1(UserID) on delete cascade;
ALTER TABLE WishList ADD CONSTRAINT fk_wishlist_User FOREIGN KEY(UserID) REFERENCES Users1(UserID) on delete cascade;
ALTER TABLE Reviews ADD CONSTRAINT fk_productId FOREIGN KEY(UserID) REFERENCES Users1(UserID) on delete cascade;
ALTER TABLE Orders ADD CONSTRAINT fk_order_UserdID FOREIGN KEY(UserID) REFERENCES User1(UserdID) on delete cascade;


ALTER TABLE Cart_Product ADD CONSTRAINT fk_cartProduct FOREIGN KEY(ShoppingCartID) REFERENCES Shopping_Cart(ShoppingCartID) on delete cascade;

ALTER TABLE WishList_Product ADD CONSTRAINT fk_wishlistProduct FOREIGN KEY(WishlistID) REFERENCES Wishlist(WishlistID) on delete cascade;

ALTER TABLE Reviews ADD CONSTRAINT fk_productId FOREIGN KEY(ProductID) REFERENCES Product(ProductID) on delete cascade;
ALTER TABLE Shopping_Cart ADD CONSTRAINT fk_cartProduct1 FOREIGN KEY(ProductID) REFERENCES Product(ProductID) on delete cascade;
ALTER TABLE Order_Product ADD CONSTRAINT fk_Order_Product FOREIGN KEY(ProductID) REFERENCES Product(ProductID) on delete cascade;
ALTER TABLE Offer ADD CONSTRAINT fk_OfferProductID FOREIGN KEY(ProductID) REFERENCES Product(ProductID) on delete cascade;
ALTER TABLE Cart_Product ADD CONSTRAINT fk_cartProduct1 FOREIGN KEY(ProductID) REFERENCES Product(ShoppingCartID) on delete cascade;

ALTER TABLE Order_Product ADD CONSTRAINT fk_Order_Product1 FOREIGN KEY(OrderID) REFERENCES Orders(OrderID) on delete cascade;
ALTER TABLE Invoice ADD CONSTRAINT fk_invoice_order FOREIGN KEY(OrderID) REFERENCES Orders(OrderID) on delete cascade;
ALTER TABLE Payment ADD CONSTRAINT fk_invoice_order FOREIGN KEY(OrderID) REFERENCES Orders(OrderID) on delete cascade;

ALTER TABLE Orders ADD CONSTRAINT fk_order_ship FOREIGN KEY(ShipperID) REFERENCES Shipper(ShipperID) on delete cascade;

ALTER TABLE Payment_Card ADD CONSTRAINT fk_card_payment FOREIGN KEY(PaymentID) REFERENCES Payment(PaymentID) on delete cascade;
ALTER TABLE Payment_Giftcard ADD CONSTRAINT fk_giftcard_payment FOREIGN KEY(PaymentID) REFERENCES Payment(PaymentID) on delete cascade;
