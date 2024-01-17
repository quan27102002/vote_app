// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vote_app/widget/login/Auth_error.dart';
import 'package:vote_app/widget/login/Model_user.dart';

 class AuthLogin {
  bool? isLoading;
  AuthError? authError;
  User? user;
  AuthLogin({
    this.isLoading,
    this.authError,
    this.user,
  });
  AuthLogin.initial(){
    isLoading=false;
  }
}
class LogInProgress extends AuthLogin{
  LogInProgress(): super(isLoading:true);
}
class LogInSucess extends AuthLogin{
LogInSucess( User user):super(isLoading: false,user: user);
}
class LogInFailre extends AuthLogin{
  LogInFailre(AuthError authError):super(isLoading: true,authError: authError);
}