const express = require("express");
const {
  registerUser,
  currentUser,
  loginUser,
  getS
} = require("../controllers/userController");
const validateToken = require("../middleware/validateTokenHandler");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/current", validateToken, currentUser);

router.get("/getS", getS);

module.exports = router;
