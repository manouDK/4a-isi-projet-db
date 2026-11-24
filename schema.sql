-- Projet : Pol-eat-heck
-- Description : Schéma de la base de données SQLite

PRAGMA foreign_keys = ON;

-- Table des utilisateurs

CREATE TABLE IF NOT EXISTS user (
    id_user TEXT PRIMARY KEY NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL
);


-- Table des utilisateurs standards

CREATE TABLE IF NOT EXISTS standard_user (
    id_user TEXT PRIMARY KEY NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    state INTEGER NOT NULL DEFAULT 0,

    CHECK (state IN (0, 1)),

    FOREIGN KEY (id_user)
        REFERENCES user(id_user)
);


-- Table des administrateurs

CREATE TABLE IF NOT EXISTS administrator (
    id_user TEXT PRIMARY KEY NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,

    FOREIGN KEY (id_user)
        REFERENCES user(id_user)
);


-- Table des produits

CREATE TABLE IF NOT EXISTS product (
    id_product TEXT PRIMARY KEY NOT NULL,
    price INTEGER NOT NULL,
    name TEXT NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    availability INTEGER NOT NULL DEFAULT 1,

    CHECK (price >= 0),
    CHECK (stock >= 0),
    CHECK (availability IN (0, 1))
);



-- Table des menus

CREATE TABLE IF NOT EXISTS menu (
    id_menu TEXT PRIMARY KEY NOT NULL,
    price INTEGER NOT NULL,
    name TEXT NOT NULL,
    availability INTEGER NOT NULL DEFAULT 1,
    start_date TEXT,
    end_date TEXT,

    CHECK (price >= 0),
    CHECK (availability IN (0, 1)),

    CHECK (
        (start_date IS NULL AND end_date IS NULL)
        OR
        (start_date IS NOT NULL AND end_date IS NOT NULL
         AND start_date <= end_date)
    )
);



-- Table des jours de fermeture

CREATE TABLE IF NOT EXISTS closure (
    id_closure TEXT PRIMARY KEY NOT NULL,
    closure_date TEXT NOT NULL UNIQUE,
    reason TEXT
);




-- Association entre les menus et les produits

CREATE TABLE IF NOT EXISTS menu_product (
    id_product TEXT NOT NULL,
    id_menu TEXT NOT NULL,
    quantity INTEGER NOT NULL,

    PRIMARY KEY (id_product, id_menu),

    FOREIGN KEY (id_product)
        REFERENCES product(id_product),

    FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu),

    CHECK (quantity > 0)
);








-- Table des commandes

CREATE TABLE IF NOT EXISTS customer_order (
    id_order INTEGER PRIMARY KEY AUTOINCREMENT,
    order_date TEXT NOT NULL,
    pickup_date TEXT NOT NULL,
    unit_price INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'RESERVED',

    id_user TEXT NOT NULL,
    id_product TEXT,
    id_menu TEXT,

    FOREIGN KEY (id_user)
        REFERENCES user(id_user),

    FOREIGN KEY (id_product)
        REFERENCES product(id_product),

    FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu),

    CHECK (unit_price >= 0),

    CHECK (pickup_date >= order_date),

    CHECK (
        status IN (
            'RESERVED',
            'COLLECTED',
            'NO_SHOW',
            'CANCELLED'
        )
    ),

    CHECK (
        (id_product IS NOT NULL AND id_menu IS NULL)
        OR
        (id_product IS NULL AND id_menu IS NOT NULL)
    )
);











