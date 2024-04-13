class Item {
  String sellerName;
  String sellerId;
  String title;
  List<String> imgUrl;
  String price;
  String description;
  String category;
  Item({
    required this.sellerName,
    required this.sellerId,
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.description,
    required this.category,
  });
}

var categoryList = [
  'Laptops & PCs',
  'Mobiles & Tablets',
  'Audio & Wearables',
  'Cameras & Lens',
  'Home Appliances',
  'Clothing',
  'Shoes & Footwear',
  'Furniture',
  'Cars',
  'Bikes',
  'Books & Stationery',
  'Musical Instruments',
  'Others',
];

var products = [
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'BMW X1',
    'imgUrl': [
      'https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/140591/x1-exterior-right-front-three-quarter-7.jpeg?isig=0&q=80',
      'https://cdni.autocarindia.com/utils/imageresizer.ashx?n=https://cms.haymarketindia.net/model/uploads/modelimages/BMW-iX1-181020231530.jpg&w=872&h=578&q=75&c=1',
      'https://carstreetindia.com/blogs/wp-content/uploads/2022/09/25-1024x683.jpg',
    ],
    'price': '98000000',
    'description': 'This is a product description',
    'category': 'Cars'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'SuperBike',
    'imgUrl': [
      'https://www.bennetts.co.uk/-/media/bikesocial/2022-december-images/top-10-ten-fastest-bikes/top-10-ten-fastest-bikes_01.ashx?h=493&la=en&w=740&hash=3DD4A469779362F2F4C636865D1DF7B231FCAA11',
      'https://i.pinimg.com/originals/09/ff/42/09ff4234fc03b71fc20162fa71be4871.jpg',
      'https://dujour.com/wp-content/uploads/e/ego-superbike-motorcycle-hero-B-500x600.jpg',
    ],
    'price': '123000',
    'description': 'This is a product description',
    'category': 'Bikes'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Iphone 15',
    'imgUrl': [
      'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-card-40-iphone15hero-202309_FMT_WHH?wid=508&hei=472&fmt=p-jpg&qlt=95&.v=1693086369781',
      'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-finish-select-202309-6-1inch_GEO_EMEA_FMT_WHH?wid=1280&hei=492&fmt=p-jpg&qlt=80&.v=1692925259606',
      'https://the-istore.ru/upload/iblock/244/x0q58jyzw0k5z4ts4pxgnbh2d36pr2v9.jpg',
    ],
    'price': '69999',
    'description': 'This is a product description',
    'category': 'Mobiles'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Canon DSLR',
    'imgUrl': [
      'https://www.cameralabs.com/wp-content/uploads/2019/08/canon-eos-90d-hero-1.jpg',
    ],
    'price': '98000',
    'description': 'This is a product description',
    'category': 'Cameras'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Chair',
    'imgUrl': [
      'https://www.at-home.co.in/cdn/shop/products/FIACCAPRICASFACGRY.jpg?v=1653041154',
    ],
    'price': '30000',
    'description': 'This is a product description',
    'category': 'Furniture'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Macbook M1',
    'imgUrl': [
      'https://5.imimg.com/data5/SELLER/Default/2021/1/WD/IM/SX/18942538/new-apple-macbook-pro-with-apple-m1-chip-13-inch-8gb-ram-256gb-ssd--500x500.jpg'
    ],
    'price': '98000',
    'description': 'This is a product description',
    'category': 'Laptops'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Nike Shoes',
    'imgUrl': [
      'https://media.wired.com/photos/63728604691ed08cc4b98976/4:3/w_1880,h_1410,c_limit/Nike-Swoosh-News-Gear.jpg',
    ],
    'price': '32000',
    'description': 'This is a product description',
    'category': 'Shoes'
  },
];

var featuredItem = [
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Macbook M1',
    'imgUrl': [
      'https://5.imimg.com/data5/SELLER/Default/2021/1/WD/IM/SX/18942538/new-apple-macbook-pro-with-apple-m1-chip-13-inch-8gb-ram-256gb-ssd--500x500.jpg'
    ],
    'price': '98000',
    'description': 'This is a product description',
    'category': 'Laptops'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Nike Shoes',
    'imgUrl': [
      'https://media.wired.com/photos/63728604691ed08cc4b98976/4:3/w_1880,h_1410,c_limit/Nike-Swoosh-News-Gear.jpg',
    ],
    'price': '32000',
    'description': 'This is a product description',
    'category': 'Shoes'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'Iphone 15',
    'imgUrl': [
      'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-card-40-iphone15hero-202309_FMT_WHH?wid=508&hei=472&fmt=p-jpg&qlt=95&.v=1693086369781',
      'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-finish-select-202309-6-1inch_GEO_EMEA_FMT_WHH?wid=1280&hei=492&fmt=p-jpg&qlt=80&.v=1692925259606',
      'https://the-istore.ru/upload/iblock/244/x0q58jyzw0k5z4ts4pxgnbh2d36pr2v9.jpg',
    ],
    'price': '69999',
    'description': 'This is a product description',
    'category': 'Mobiles'
  },
  {
    'sellerName': 'ankit',
    'sellerId': 'lrm8woLlSxfxuH5TJX8qEqjILun1',
    'title': 'SuperBike',
    'imgUrl': [
      'https://www.bennetts.co.uk/-/media/bikesocial/2022-december-images/top-10-ten-fastest-bikes/top-10-ten-fastest-bikes_01.ashx?h=493&la=en&w=740&hash=3DD4A469779362F2F4C636865D1DF7B231FCAA11',
      'https://i.pinimg.com/originals/09/ff/42/09ff4234fc03b71fc20162fa71be4871.jpg',
      'https://dujour.com/wp-content/uploads/e/ego-superbike-motorcycle-hero-B-500x600.jpg',
    ],
    'price': '123000',
    'description': 'This is a product description',
    'category': 'Bikes'
  },
];
