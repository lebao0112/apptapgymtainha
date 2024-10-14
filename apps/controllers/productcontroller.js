var express = require("express");
const { ObjectId } = require("mongodb");
var router = express.Router();
var Product = require("./../entity/product");
var ProductService = require("./../services/productService");
const multer = require("multer");

// Set up Multer storage
const storage = multer.memoryStorage(); // Store file in memory as a Buffer
const upload = multer({ storage: storage });

router.get("/", function (req, res) {
  res.json({ message: "this is product" });
});

// router.get("/product-list", async function (req, res) {
//   var productService = new ProductService();
//   var product = await productService.getProductList();
//   res.json(product);
// });

// router.get("/get-product", async function (req, res) {
//   var productService = new ProductService();
//   var product = await productService.getProduct(req.query.id);
//   res.json(product);
// });

router.post(
  "/insert-product",
  upload.single("productimage"),
  async function (req, res) {
    const productService = new ProductService();
    const pro = new Product();
    pro.Name = req.body.Name;
    pro.Price = req.body.Price;
    pro.Description = req.body.description;

    // Store the image as binary (Buffer)
    if (req.file) {
      pro.productimage = req.file.buffer; // Save the binary data (image)
    }

    const result = await productService.insertProduct(pro);
    res.redirect("/product/product-list");
  }
);

// Update product with image upload handling
router.post(
  "/update-product",
  upload.single("productimage"),
  async function (req, res) {
    const productService = new ProductService();
    const pro = new Product();
    pro._id = new ObjectId(req.body.Id);
    pro.Name = req.body.Name;
    pro.Price = req.body.Price;
    pro.Description = req.body.Description;

    // If a new image is uploaded, update the productimage field
    if (req.file) {
      pro.productimage = req.file.buffer;
    } else {
      // If no image is uploaded, retain the existing image from the database
      const existingProduct = await productService.getProduct(req.body.Id);
      pro.productimage = existingProduct.productimage;
    }

    await productService.updateProduct(pro);
    res.redirect("/product/product-list");
  }
);

router.post("/delete-product", async function (req, res) {
  var productService = new ProductService();
  await productService.deleteProduct(req.query.id);
  res.redirect("/product/product-list");
});

// var express = require("express");
// var router = express.Router();
// var ProductService = require("./../services/productService");

// Serve the Create Product page
router.get("/create-product", function (req, res) {
  res.render("product/create-product");
});

// Serve the Update Product page
router.get("/update-product", async function (req, res) {
  var productService = new ProductService();
  var product = await productService.getProduct(req.query.id);
  res.render("product/update-product", { product });
});

// Serve the Delete Product page
router.get("/delete-product", async function (req, res) {
  var productService = new ProductService();
  var product = await productService.getProduct(req.query.id);
  res.render("product/delete-product", { product });
});

// Serve the Product List page
router.get("/product-list", async function (req, res) {
  var productService = new ProductService();
  var products = await productService.getProductList();
  res.render("product/product-list", { products });
});

module.exports = router;
