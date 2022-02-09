INSERT INTO canteen VALUES(1, 'Some Place', 'QR Canteen', 123);
INSERT INTO users VALUES(2, '3409d233795adbf1043d94f1f2ab376e33d9df4eab6ad071b71160c278b1adcf', 1, 'QrStaff', null);
INSERT INTO users VALUES(3, '271b7b11548aee79bf3a1c5a30aa2a1797dd5a07993b02eb4f8d62cedaab0c0f', 2, 'QrUser', null);
INSERT INTO dish VALUES(1, 2, 'QR Dish', 123, 1);
INSERT INTO orders VALUES(1, 1644323114, false, 1, 3);
INSERT INTO order_has_dish VALUES(1, 3, 1, 1);
