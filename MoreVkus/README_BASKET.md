# Basket Functionality Implementation

## Overview
This document explains the implementation of the basket (cart) functionality in the MoreVkus app. The basket allows users to add, update, and remove products, with the state synchronized across all screens.

## Key Components

### 1. BasketManager

A singleton class that manages the basket state:

- Stores product information with quantities
- Provides methods to add, remove, and update products
- Publishes notifications when the basket changes
- Persists basket data using UserSettings
- Calculates total price and number of items

### 2. BasketController

A view controller that displays the products in the basket:

- Shows a list of products with image, name, price, and quantity
- Allows increasing/decreasing quantity
- Allows removing products
- Shows the total price
- Has a checkout button
- Shows a message when the basket is empty

### 3. BasketCell

A custom table view cell for products in the basket:

- Displays product information
- Has buttons to increase/decrease quantity
- Has a button to remove the product from the basket

### 4. Integration with MilkProducts

Updates to the MilkProducts screen to integrate with the basket:

- Updated the UI to show when products are in the basket
- Added buttons to add/remove products
- Synchronized basket state with product display

### 5. Integration with CatalogController

Updates to the CatalogController to integrate with the basket:

- Added a basket button to the navigation bar
- Displays a badge with the number of items in the basket
- Provides navigation to the basket screen

## How It Works

1. When a user taps "Add to basket" on a product:
   - The product is added to the basket via BasketManager
   - BasketManager updates the data in UserSettings
   - BasketManager sends a notification of the change

2. When a user changes quantity or removes an item in the basket:
   - BasketManager updates the quantity or removes the item
   - BasketManager updates the data in UserSettings
   - BasketManager sends a notification of the change

3. When a notification is received:
   - The UI is updated to reflect the current basket state
   - MilkProducts updates product cells to show correct quantities
   - CatalogController updates the basket badge count

## Basket Data Storage

The basket data is stored in UserSettings as an array of BasketInfo arrays. Each BasketInfo object contains:

- Product ID
- Product title
- Price
- Quantity
- Category ID
- Availability status

## Notification Types

- `basketUpdatedNotification`: General notification that the basket was updated
- `productAddedNotification`: A product was added to the basket
- `productRemovedNotification`: A product was removed from the basket
- `productQuantityChangedNotification`: A product's quantity was changed

## Code Structure

1. BasketManager.swift - Core logic for basket operations
2. BasketController.swift - UI for displaying and managing the basket
3. Integration in MilkProducts.swift - UI for adding products to basket
4. Integration in CatalogController.swift - Navigation and basket indicator 