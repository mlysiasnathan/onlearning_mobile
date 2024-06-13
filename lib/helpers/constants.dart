var ipLocalAddress = '192.168.13.90';
var baseURL = 'http://$ipLocalAddress/onlearning/public/api';
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
