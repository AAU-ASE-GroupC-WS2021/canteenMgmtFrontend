DELETE FROM order_has_dish;
DELETE FROM orders;
DELETE FROM menu_menu_dish_names;
DELETE FROM menu;
DELETE FROM auth;
DELETE FROM users;
DELETE FROM dish;
DELETE FROM canteen;

INSERT INTO users VALUES(1, d4453016378d0f001181dae5d14b70196f1eb094d67abcc911b4bb6ba21168c4, 0, owner, null);