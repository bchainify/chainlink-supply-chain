// This example code is designed to quickly deploy an example contract using Remix.
pragma solidity ^0.6.0;

contract ProductsOnMarket {
  string public name;
  uint public itemCount=0;
  mapping(uint => Product) public products;

struct Product {
  uint id;
  string name;
  uint price;
  address payable owner;
  bool purchased;
}

event ProductCreated (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool purchased
);

event ProductPurchased (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool purchased
);
  constructor() public {
    name = "Chainlink Hackathon demo for getting products details via UPC barcodes";
  }

  function createProduct(string memory _name, uint _price) public {
    //Require a name
    require(bytes(_name).length > 0, "Enter a valid name");
    //Requiere a valid price
    require(_price > 0, "Enter a valid price");
    //Increment product count
    itemCount++;
    //Create the product
    products[itemCount] = Product(itemCount, _name, _price, msg.sender, false);
    //Trigger an event
    emit ProductCreated(itemCount, _name, _price, msg.sender, false);
  }

  function purchaseProduct(uint _id) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= itemCount, "Enter valid id");
    //Require that there is enough Ether in the transaction
    require(msg.value >= _product.price,"Transfer the correct amount");
    //Require that the product has not been purchased already
    require(!_product.purchased, "Product has been purchased");
    //Require that the buyer is not the seller
    require(msg.sender != _seller, "Buyer cannot be seller");
    //Transfer ownership to the buyer
    _product.owner = msg.sender;
    //Mark as purchased
    _product.purchased = true;
    //Update the product
    products[_id] = _product;
    //Pay the seller by sending them Ether
    _seller.transfer(msg.value);
    //Trigger an event
    emit ProductPurchased(itemCount, _product.name, _product.price, msg.sender, true);
  }
}