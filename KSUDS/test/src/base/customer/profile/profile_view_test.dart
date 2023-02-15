import 'package:test/test.dart';
import 'package:kcds/utils/validator.dart';

void main() {
test('empty Name returns error stirng',(){
   var result=  FieldValidator.validateName('') ;
   expect (result,'Please enter your full name');
  });
test('non empty name return null', (){
  var name='aljoury ibrahim';
 var result= FieldValidator.validateName(name) ;
 expect(result, null);
});

  test('Name contains invalid characters return error string', (){
   var username= "joury/^^";
    var result= FieldValidator.validateName(username) ;
    expect(result, 'Incorrect full name');
});
  test('empty Phone number returns error stirng',(){
   var result=  FieldValidator.validatePhoneNumber('') ;
   expect (result,'Please enter your phone number');
  });
test('non empty name return null', (){
 var result= FieldValidator.validatePhoneNumber('96655248399') ;
 expect(result, null);
});
  test('Phone number less than or equal 8 error stirng',(){
    var number="5524899";
   var result=  FieldValidator.validatePhoneNumber(number) ;
   expect (result,'Invalid number');
  });
test(' Phone number with wrong pattren error stirng',(){
    var number="55248//99";
   var result=  FieldValidator.validatePhoneNumber(number) ;
   expect (result,'Invalid Number');
  });
}