import 'package:test/test.dart';
import 'package:kcds/utils/validator.dart';


void main() {
  
  test('empty email returns error stirng',(){
   var result= FieldValidator.validateEmail('') ;
   expect (result,'Please Enter email address');
  });
test('non empty email return null', (){
 var result= FieldValidator.validateEmail('email@gmail.com') ;
 expect(result, null);
});

test('email contains invalid characters return error string', (){
  var email4="joury^^^^gmail.com";
    var result= FieldValidator.validateEmail(email4);
    expect(result, 'Invalid Email');
});


}