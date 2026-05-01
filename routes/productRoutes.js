const express = require('express');
const router = express.Router();
const controller = require('../controllers/productController');
const validators = require('../validators/productValidator');
const { validationResult } = require('express-validator');
const multer = require('multer');
const { S3Client } = require('@aws-sdk/client-s3');
const multerS3 = require('multer-s3');

// Cấu hình AWS S3 Client (v3)
const s3 = new S3Client({
  region: process.env.AWS_REGION || 'ap-southeast-1',
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  }
});

// Cấu hình Multer-S3
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.S3_BUCKET_NAME,
    acl: 'public-read',
    key: function (req, file, cb) {
      const safe = Date.now() + '-' + file.originalname.replace(/[^a-zA-Z0-9.\-_]/g, '_');
      cb(null, safe);
    }
  })
});

function handleValidation(req, res, next) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  next();
}

router.get('/', controller.list);
router.get('/:id', controller.getOne);
router.post('/', upload.single('imageFile'), validators.create, handleValidation, controller.create);
router.put('/:id', upload.single('imageFile'), validators.put, handleValidation, controller.put);
router.patch('/:id', upload.single('imageFile'), validators.patch, handleValidation, controller.patch);
router.delete('/:id', controller.remove);

module.exports = router;