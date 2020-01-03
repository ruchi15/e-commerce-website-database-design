
CREATE OR REPLACE TRIGGER CHECK_OFFER_AMOUNT 
AFTER INSERT ON OFFER FOR EACH ROW
BEGIN
dbms_output.put_line('CALLING CHECK_OFFER_AMOUNT');
    IF :NEW.OfferAmount > 100
    THEN
      Raise_Application_Error(-20000, 'Offer Amount Cannot Exceed 100');
    END IF;
END;

CREATE OR REPLACE TRIGGER CHECK_CART_QUANTITY 
AFTER INSERT ON Shopping_Cart FOR EACH ROW
BEGIN
    IF :NEW.Quantity > 10
    THEN
      Raise_Application_Error(-20001, 'Quantity cannot exceed 10');
    END IF;
END;



CREATE OR REPLACE TRIGGER CART_DROP 
AFTER INSERT ON Orders FOR EACH ROW
Declare 
UID VARCHAR(8);
ShID VARCHAR(8);
BEGIN
    Select ShoppingCartID INTO ShID from Shopping_Cart where UserID = :New.UserID;
    Delete from Cart_Product where ShoppingCartID = ShID;
    Delete from shopping_cart where shoppingcartid = ShID;
END;

set serveroutput on;
CREATE OR REPLACE TRIGGER Change_Order_Status 
AFTER INSERT ON Payment FOR EACH ROW
Declare 
BEGIN
    Update Orders Set transactionstatus = 'SUCCESS' where orderid = :New.OrderID;
    dbms_output.put_line(:New.OrderID);
END;


CREATE OR REPLACE TRIGGER Check_inventory 
BEFORE INSERT ON Cart_Product FOR EACH ROW
Declare 
ProdID VARCHAR(8);
Qty INT;
BEGIN
    Select UnitsInStock INTO Qty from Product where ProductID = :NEW.ProductID;
    IF Qty <= 0 
    THEN
        Raise_Application_Error(-20002, 'Product Out Of Stock');
    END IF;  
END;
