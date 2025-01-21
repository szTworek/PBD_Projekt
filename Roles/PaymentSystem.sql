CREATE ROLE PaymentSystem
GRANT EXECUTE ON AddToCart TO PaymentSystem;
GRANT EXECUTE ON AddWebinarPayment TO PaymentSystem;
GRANT EXECUTE ON AddOrderPayment TO PaymentSystem;