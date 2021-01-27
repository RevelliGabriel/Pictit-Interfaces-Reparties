var express = require('express');
var router = express.Router();
const fs = require('fs');

router.param('id', function (req, res, next, id) {
  // sample user, would actually fetch from DB, etc...
  let data = fs.readFileSync('db/users.json');
  let users = JSON.parse(data).users;

  console.log(users)

  let user = users.filter(user => user.id == id)[0];

  console.log(user)

  if(!user) {new Error('no user found')}

  req.user = {
    id: user.id,
    name: user.name
  }

  next()
})

router.route('/:id')
  .all(function (req, res, next) {
    // runs for all HTTP verbs first
    // think of it as route specific middleware!
    next()
  })
  .get(function (req, res, next) {
    res.json(req.user)
  })
  .put(function (req, res, next) {
    // just an example of maybe updating the user
    req.user.name = req.params.name
    // save user ... etc
    res.json(req.user)
  })
  .post(function (req, res, next) {
    next(new Error('not implemented'))
  })
  .delete(function (req, res, next) {
    next(new Error('not implemented'))
  })

module.exports = router;
