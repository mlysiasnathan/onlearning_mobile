var ipLocalAddress = '192.168.10.130';
var baseURL = 'https://$ipLocalAddress/onlearning/public/api';
// const baseURL = 'http://onlearning.test/public/api';
var loginURL = '$baseURL/login';
var registerURL = '$baseURL/register';
var logoutURL = '$baseURL/logout';
var userURL = '$baseURL/user/profil';
var categoriesURL = '$baseURL/categories';
var addCategoryURL = '$baseURL/category/create';
var assetsURL = 'http://$ipLocalAddress/onlearning/public';

const String serverError = 'Server error or bad network';
const String unauthorized = 'Unauthorized! Please login first';
const String somethingWentWrong = 'Something went wrong, Try again';

const List<String> assetImages = [
  'assets/images/logo_mini.png',
  'assets/images/onlearning_logo.jpg',
  'assets/images/onlearning_logo.png',
  'assets/images/placeholder.PNG',
  'assets/images/unknown.png',
  'assets/images/line.jpg'
];
